Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617175F60E8
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 08:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJFGPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 02:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiJFGPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 02:15:34 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C0032BB2
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 23:15:33 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bh13so1016648pgb.4
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 23:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=kj+F1FdX6TBtLaOY1xSPqr94l0+FKqRuo16DwkvlxEE=;
        b=PObcqm3IzCwc757kBP2Q7Eyui7OzKd/12rm7vRG+wpuxZ4mPelGW9iVt8ASLClcGaf
         D3KrdSGtpb/ZV+IvTxZgb1+dsp2/FhGzS256KwEj7fHrEK8KNoqkWLFDpxorI6BpyVp3
         E+uCHLTgsr0JxeR4WB++S26SFRCGOZhEzxYos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=kj+F1FdX6TBtLaOY1xSPqr94l0+FKqRuo16DwkvlxEE=;
        b=6JBxqHvEr/5eof37n03ITzXgnUWmG/OEt6WM+NSHHxlE7W0j4wUxAiqylbsh7Cmml7
         JDP0rBWaYUgMXz6Uhut1tRtqfHBLMwRL12VAys4bWXHjl5HIB8eMYNhavPLW1bDcTQq+
         namxzeiYKrAwoGpgUXrykUEaLcOTASm/DBYZDfFJzkLCHbFWnmiT9F1ArfL/5ySAqVbk
         CPT3OyNvx/hFKegXy37guWhrpfWsTnHY2Uo4kbN7/A+fMeUVLiLdcQBi4uOkoFWUqhsw
         A+0hcwJvDSbRq8d7rSZSyXp+lxmC/lZ+HsPaLtnfNnqeI4edz925BbB6vWzOuukNTiUq
         1XIA==
X-Gm-Message-State: ACrzQf2O8r2yWR0fm7F1i2uUceHc/iZEiXckSWmI2vUsWiMKg+DsUPNf
        b0TjeKrH5X/lgb78MG/+6KCw5Q==
X-Google-Smtp-Source: AMsMyM5V4+F5de7QUB2CRoC6OFZ0KmWRsmdDah9tMdCebp8K/z8shaAJiN3iu+cTBS4Xzu2mmaYqPQ==
X-Received: by 2002:a05:6a00:124e:b0:561:b241:f47f with SMTP id u14-20020a056a00124e00b00561b241f47fmr3570089pfi.72.1665036932903;
        Wed, 05 Oct 2022 23:15:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i15-20020a63584f000000b004393c5a8006sm873327pgm.75.2022.10.05.23.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 23:15:32 -0700 (PDT)
Date:   Wed, 5 Oct 2022 23:15:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v1 0/5] treewide cleanup of random integer usage
Message-ID: <202210052310.BF756EBEBE@keescook>
References: <20221005214844.2699-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005214844.2699-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 11:48:39PM +0200, Jason A. Donenfeld wrote:
> I've CC'd get_maintainers.pl, which is a pretty big list. Probably some
> portion of those are going to bounce, too, and everytime you reply to

The real problem is that replies may not reach the vger lists:

Subject: BOUNCE linux-kernel@vger.kernel.org: Header field too long (>8192)

But the originals somehow ended up on lore?

https://lore.kernel.org/lkml/20221005214844.2699-1-Jason@zx2c4.com/

-- 
Kees Cook
