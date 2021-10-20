Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38C6434CA8
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhJTNwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhJTNwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 09:52:38 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03F3C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 06:50:23 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id w8so3042168qts.4
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 06:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1aPhoSYlZ+vIBMBmFLOBpRr+rtkUB/unER397PgMb/s=;
        b=gZtSCoBISV4C0V6x60c8dQxCDYkJTPasn89EAt23pzpcB2sVgN5IRl7kz2ABzhAiHF
         PLkdsFoYuUfZ1FeAQVoBE61bYTpWfp7VdKhW9FdVLwzIEavTBjRspms/Oh6TscQbYyZl
         IPH3I74YM0Db9jrnUrirnTqjbtdGSQZ0KmkT1q6KsHuOswvLXBPd5J7Sz5AOx8ix4Gyz
         5VrvLLAtF7pfdWOnkCgJYYEg0HsAQo47Tt3oTzTccByNGyhVB+O5C/9SaJAapFzW6Zkf
         5OkPZYC2TrxL28zvKRCMJHBmcgvHzTOhxCPnoD6lUlkRxYIs5M8K1U9LUjEmQzFgkvXY
         dkGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1aPhoSYlZ+vIBMBmFLOBpRr+rtkUB/unER397PgMb/s=;
        b=JhnUrJfYVDbaj5OoAqo7AQRUv1daYIAS8crP9Ih51UZ5+oNoTl8nvV1hJJceMSDJON
         P/v6wilmktqyJ5CaPvWKZOJnhmG2h+xlEvUsGpkrlXlLJl117ZZKc5zIAML2WGjdExcp
         MCvZRp0VSMTOv7dB5U32s7PhANRM4Sa+CxTyl1G7GpRGaXEzjaAIvHtFedccSiCKAxf4
         amK7DYb2AicljCowgWNVeFG0gT5wQqLUZrXDzQe0pO7kEWZuFB5q7JoTDSInnk3SCu04
         e7QdMuUaCEMCovFRULKZWxb/AcfycrjNLemvG0N/GKoTXWRjPdkkQbCcrgN7+CMRrHiv
         sdSQ==
X-Gm-Message-State: AOAM533imxrvTsG4xlaMbsWLXWDg/SXnrQqJTn+I6O7BTPztGfwfCEpU
        XLwsUqXpMwIXBQ1Ak8i2mAfsCSOd1w==
X-Google-Smtp-Source: ABdhPJyU7iKLNg2mIcdsiHdn+M5usGoj2oF/+kpoRFjqwyDCkcaOZqx6dRtWspRlO6jlYqF5Ehfkew==
X-Received: by 2002:ac8:5f06:: with SMTP id x6mr7061598qta.295.1634737823109;
        Wed, 20 Oct 2021 06:50:23 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id h125sm1017968qkc.29.2021.10.20.06.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 06:50:22 -0700 (PDT)
Date:   Wed, 20 Oct 2021 09:50:18 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Antonio Quartulli <a@unstable.cc>
Cc:     netdev@vger.kernel.org
Subject: Re: Sysctl addr_gen_mode does not control tunnel link-local addr
Message-ID: <20211020135018.GA21437@ICIPI.localdomain>
References: <20211020013005.GA4864@ICIPI.localdomain>
 <cee7948d-a637-ca07-6788-61500672f8cf@unstable.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cee7948d-a637-ca07-6788-61500672f8cf@unstable.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 02:59:01PM +0200, Antonio Quartulli wrote:

> For sure, supporting IN6_ADDR_GEN_MODE_NONE is a low hanging fruit and
> should be implemented.
> 
Thanks for reaffirming this!

> Other than my nitpick above, I'd suggest applying the same change to the
> GRE code path, as the behavior should be the same.

> Moreover, do you think that addrconf_add_mroute() should not be executed
> in this case? Otherwise you could simply add your new code into
> add_v4_addrs().

Initially I was thinking that why there is a need to call
addrconf_add_mroute() given the link-local addr hasn't been set. On a
second look, yes, the conditional is better be in add_v4_addrs(). It
will take care of GRE as well.

I'll put a formal patch.

Thanks!
