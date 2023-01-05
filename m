Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F6E65E770
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjAEJPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjAEJPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:15:01 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A026A5015E
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:15:00 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id co23so35495848wrb.4
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 01:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0XXeR6ACYrioOAv7EhNvbvR9u/A2N6dg5skH1lYUbxU=;
        b=QacVO57mjJp1dDUvzcsik0rQYhj0OekG02MY3k1OPffnE4Q2WMIIkjVDYE51Mq4dw9
         YmKDSx9X94wpcCPzSeytBx7nsjnSfBUgYsue4FVv8oW6HZhUCPp1ng31iwcthc7C8VmL
         DBtaq23dg2KVqjYHvVgby15C+r03iLVIw3IDNtFW8RtvtMOIm6JCp8PQe/u55WYJTvCa
         3K/FtK/upt0X3gMu7fqroabhmFFWhBh4de7seSB4019qoDI/awPNRCzmkYdt+gDs+WEW
         w7X6ec7o7ns+uaegAsx/PdhGS38riAYrFXH6Ak8G+igbkYIdsjSjs4RZ4smT6vXT4hnF
         pdrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XXeR6ACYrioOAv7EhNvbvR9u/A2N6dg5skH1lYUbxU=;
        b=Rt8Sm+8BJ4AIYG3haMd+2maJm/98h97ydLbJh/O/icBL/BZbj53mEZyGPyVPXysxHO
         R6y6IldYzkRSbGLcz8BiYOq0Kf16BLCXntTrBy06Zj3mg8OvdH1mKLJuRSLce3hykSpl
         Iy/URYYsLPzYwHXz4ZJI/w1ftIadZWqX8e94OlUPspM6kZ5Gw9i57QTNluNtOhSMiRs+
         fgIajSo3FEZFRDFQ4xLbJcJs/tlukyu/balujZPLHZZRGndFNYZbU7PhHKQjUgCRd5Nt
         RpKczxvxUn6mY5fzDyQLAUE0EcgaPDCgwXX2j7qCYdM+9r8EN7DH6IZ6XabkGMrQOKeT
         Q5dw==
X-Gm-Message-State: AFqh2koqUi0GVGZbWzYW+QdtwFtregl4/j+SeNeStiELTADbrN6csAxs
        s17S1rC/x8Eq10/CDIY7Qut5/w==
X-Google-Smtp-Source: AMrXdXt4aWyX5o5pkOxA2DNoqaskh5TRRN8Xfi4Y7Z9HevQ+YIz/eAmmdxqBzmBMK7JE/hqd+eQd0Q==
X-Received: by 2002:a05:6000:d0:b0:29a:555d:2436 with SMTP id q16-20020a05600000d000b0029a555d2436mr8118962wrx.31.1672910099292;
        Thu, 05 Jan 2023 01:14:59 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p3-20020adfcc83000000b0027a57c1a6fbsm30340564wrj.22.2023.01.05.01.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:14:58 -0800 (PST)
Date:   Thu, 5 Jan 2023 10:14:57 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2 02/15] devlink: rename
 devlink_netdevice_event -> devlink_port_netdevice_event
Message-ID: <Y7aVETz4M8vZpAZJ@nanopsycho>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105040531.353563-3-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 05:05:18AM CET, kuba@kernel.org wrote:
>To make the upcoming change a pure(er?) code move rename
>devlink_netdevice_event -> devlink_port_netdevice_event.
>This makes it clear that it only touches ports and doesn't
>belong cleanly in the core.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
