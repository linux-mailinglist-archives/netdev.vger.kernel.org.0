Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED936602C5
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjAFPJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjAFPJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:09:04 -0500
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63484687B9;
        Fri,  6 Jan 2023 07:09:03 -0800 (PST)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-4a0d6cb12c5so26092657b3.7;
        Fri, 06 Jan 2023 07:09:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qK3fDVWQGXg5FS5RnUEt2ia8jXyHkl44RT+JR8v153M=;
        b=KEDfPuXrlXM8HFvuOr7YVKptgipngs72AEXXuwv962rsjWz15PMt7DhbTpmcddg4CL
         o6S8KpX9TASxmWTxTm/7hkSkC+ls9R9Uz2e6zYFCt+/UUp3cWpUAI9LxgTPfC4RjYjjG
         XIQyRTQ7LjwGT7OA7ifVTevddQFSAWfXgC6UWBi4dDAHXLn2Kq5XsrGKsoeOHvSkJH3R
         vbQJzoxQLz+30Vvy1JYpAXk+QP6bAgO7ZboIoYc3JWm+UJAEdsObnGhQZbkY4LAFUkZg
         0aHFrCb26nStv0Vut3Bl4po177nwfVbfczW+zIFRb4xYv9Grf89kqT0OoIo+d5WM0SVf
         j8LA==
X-Gm-Message-State: AFqh2koai/jeq2MFYOTZlKDl99Q02fJs2b8a6XVTyU5ud8w7fj4OIs1p
        HJBCDOMWFNyPPy7elENe8/8=
X-Google-Smtp-Source: AMrXdXtosbJGC2k2PXaOuIcAoFtUEXrzOWtl+/Nzn31WXTi8KKOyjRX2myhPGvlm/MVHWLP77JSMLw==
X-Received: by 2002:a05:7500:12d1:b0:f0:3a77:6218 with SMTP id o17-20020a05750012d100b000f03a776218mr69654gao.6.1673017742346;
        Fri, 06 Jan 2023 07:09:02 -0800 (PST)
Received: from maniforge.dhcp.thefacebook.com ([2620:10d:c091:480::1:a6f6])
        by smtp.gmail.com with ESMTPSA id m4-20020a05620a290400b00705377347b9sm643879qkp.70.2023.01.06.07.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 07:09:01 -0800 (PST)
Date:   Fri, 6 Jan 2023 09:09:01 -0600
From:   David Vernet <void@manifault.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v6 01/17] bpf: Document XDP RX metadata
Message-ID: <Y7g5jbXMrt19c9XE@maniforge.dhcp.thefacebook.com>
References: <20230104215949.529093-1-sdf@google.com>
 <20230104215949.529093-2-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104215949.529093-2-sdf@google.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 01:59:33PM -0800, Stanislav Fomichev wrote:
> Document all current use-cases and assumptions.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

This looks great, thanks Stanislav.

Acked-by: David Vernet <void@manifault.com>
