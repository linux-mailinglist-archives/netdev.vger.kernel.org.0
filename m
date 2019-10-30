Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EFDEA61B
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfJ3WXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:23:25 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40525 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfJ3WXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:23:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id r4so2657667pfl.7
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=76IATx7/zdLnxGfZdiEGXrgwCR4V0EwF/gRAEIcOrUo=;
        b=K4Y/d0uclTWTuTc/AvEydITGsQrvXM5B580Wmk6mkVWSOiR8jnoe+S/MUOLb4KlBm7
         TkrvWA0E8tkiceeGmit+5e+uS0AmyFgXr9zh2sMzjekKCh8FoyC1zQZUmNEauzoCqcxe
         cFdK998XvwsGbjGzqDdc1YOrqJIFFDFsxTnTvozKAxEDOieiaicpWGyOowCRCtmhZANo
         RqZIVqAyH+zK0sWVKw4R+U+aE+DqP89YoWzYTeagOf/6G9Mqm4xowP/GBT2EhSbob7HK
         5p737Psvg2+TNJDdIFOMN2yqz7Ez+arwbbr3MTh/JLDkvZdl+qIPC9P5XryRVernkGl+
         cJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=76IATx7/zdLnxGfZdiEGXrgwCR4V0EwF/gRAEIcOrUo=;
        b=ULuaNwVpRqELUE3Dp6Qg8H2Y7zHMPLz+xVgJ8JPBJHaY9Pixk5wD1XPRgeNFu0rQuR
         4OTPEwjfWPapkzWxhNtaFR000HEWer3Vk4qK5nL8rmqlwazWvBNrBif7CDGLzu4XIsW2
         DZ+et+uwk3TE6gbVbOsqroSEHtp62zleO9aJbTu9xoGdCvRaq/9SvnaZZlDuRQFrs+8A
         IiNsGNqbOOt5aFMU6IjXipYoUrPoVD0ndjne/MoU61Zt97Fu9EzCe0YH7aARDd7OBMl/
         XeTJygkRQDChD2FY1TGoLh39fzMBcrbOhN67uzZQmV37Hx0zDjr3eZ02z4aE+XIuv46P
         +JnQ==
X-Gm-Message-State: APjAAAUDf79WQ4WiP95w+bdxptSj0PlFSWwPJ9paoqDB7uPCCpphGNZC
        5uPeH03N2Z6LmQsbeYceeBEgCGHCdDysdw==
X-Google-Smtp-Source: APXvYqx13XSadpbrK0TYFCqp4BP4TcPu/XCiq/96uSJygShOnhOvvNv6v7bzf0RuHU9yDytzCvFtzA==
X-Received: by 2002:a17:90a:fa02:: with SMTP id cm2mr2042848pjb.129.1572474203936;
        Wed, 30 Oct 2019 15:23:23 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h13sm933998pfo.55.2019.10.30.15.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 15:23:23 -0700 (PDT)
Date:   Wed, 30 Oct 2019 15:23:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ariel Levkovich <lariel@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH 1/3] net: Support querying specific VF properties
Message-ID: <20191030152315.6ff4f2fd@hermes.lan>
In-Reply-To: <1572462854-26188-2-git-send-email-lariel@mellanox.com>
References: <1572462854-26188-1-git-send-email-lariel@mellanox.com>
        <1572462854-26188-2-git-send-email-lariel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 19:14:47 +0000
Ariel Levkovich <lariel@mellanox.com> wrote:

> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index 1418a83..09df2f4 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -760,6 +760,7 @@ enum {
>  #define RTEXT_FILTER_BRVLAN	(1 << 1)
>  #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
>  #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
> +#define RTEXT_FILTER_VF_EXT  (1 << 4)

Could you fix the line above (SKIP_STATS), it has weird indent
