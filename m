Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19EE28587C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgJGGIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgJGGIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:08:10 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5A4C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 23:08:10 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 60so1217577otw.3
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 23:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dIuoMnIxdSghVzpH0OwkNRFp6OlAQK3NM/6kBQEe0ro=;
        b=qRREHBDHZ9TYqiv9dzdV4YbYtN5FURL5YxGhNSoFyGHbP7vZOQuh2ZIw+RB0Z14j9W
         HBlRAFhkt/DnvoEsPu5xQzSarLCyRez5yn+B9vJoNzctfm9D8mvhnckSUkCeYCMLlGsb
         GtiY3rNQLOp2pltntK6l9s4wMEz5sVx8QyneYqSWTRdMFkytvYio6CLXNR7KEIhRhBWC
         yvL92E4weYM9+YnX6G5ck2R+sJTi5if1SnozXmyXk53ZgWtqr/3Eur7OCRgtHsk+QhEp
         idQZPn4pG4a1qGmm/L2H9XW9gGPfbuLlccMBNp1M9gPxvUq8PIo6FxcFim1MU9uqFN/L
         t74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIuoMnIxdSghVzpH0OwkNRFp6OlAQK3NM/6kBQEe0ro=;
        b=cpUgF8sAkuTgTsLPSRLO1ZQNW5f8S/J7CpbwNc30W8pOef7zFFEkKhYPLyeSNy7/qK
         Ia7cfEQFSRcjrzdS7Q0Twl0U3w3bFpTQF+johx2JrWdSt/+qHYkQT0DKeQo8jhNRuqF5
         oUnQpF4joQv0nIcpNKZoPuBQnsJYv9QAqmkVfSpz+njgz2X3ZmY94Ym/SN/vnRWzLf6U
         0PR6M4RQpUveDysowvcmVlhK6774dnBsFryuxbKuPRfj+zy3E2h7ydNJd8AZM7W7hsvW
         veMDVMuhr+/zTHkMYDHfEAE8ZEwRVQaXZBrBGfX0mcMzRzWlpTFPtRlduBrskra79B6o
         18jQ==
X-Gm-Message-State: AOAM530nGXujeuZwaHDvQuUjL2K7fLc+DyVi1upKfKgqai7zTbmLNMsL
        H23FedxWP/jGLEPJc8FqJlM=
X-Google-Smtp-Source: ABdhPJz72rYE0DrKhKB5quR4MDUDnbu61tZid8pAzkfK8xwDmOhLyBGB6FHKt8YTPW90mW+/RSmUBg==
X-Received: by 2002:a9d:719b:: with SMTP id o27mr633459otj.290.1602050889982;
        Tue, 06 Oct 2020 23:08:09 -0700 (PDT)
Received: from Davids-MBP.attlocal.net ([2600:1700:3eca:200:4df6:ae94:ee53:9573])
        by smtp.googlemail.com with ESMTPSA id k23sm630ool.5.2020.10.06.23.08.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 23:08:09 -0700 (PDT)
Subject: Re: [iproute2-next v2] devlink: support setting the overwrite mask
 attribute
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com
References: <20200930210547.3598309-1-jacob.e.keller@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b5926764-a68e-fa44-4b18-7e82a8880bf2@gmail.com>
Date:   Tue, 6 Oct 2020 23:08:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20200930210547.3598309-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 2:05 PM, Jacob Keller wrote:
> The recently added DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK allows
> userspace to indicate how a device should handle subsections of a flash
> component when updating. For example, a flash component might contain
> vital data such as PCIe serial number or configuration fields such as
> settings that control device bootup.
> 
> The overwrite mask allows specifying whether the device should overwrite
> these subsections when updating from the provided image. If nothing is
> specified, then the update is expected to preserve all vital fields and
> configuration.
> 
> Add support for specifying the overwrite mask using the new "overwrite"
> option to the flash command line.
> 
> By specifying "overwrite identifiers", the user request that the flash
> update should overwrite any settings in the updated flash component with
> settings from the provided flash image
> 
>   $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite identifiers
> 
> By specifying "overwrite settings" the user requests that the flash update
> should overwrite any settings in the updated flash component with setting
> values from the provided flash image.
> 
>   $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings
> 
> These options may be combined, in which case both subsections will be sent
> in the overwrite mask, resulting in a request to overwrite all settings and
> identifiers stored in the updated flash components.
> 
>   $devlink dev flash pci/0000:af:00.0 file flash_image.bin overwrite settings overwrite identifiers
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  devlink/devlink.c | 48 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 46 insertions(+), 2 deletions(-)
> 

applied to iproute2-next. Thanks


