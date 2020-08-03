Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1A723A9E9
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgHCPxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgHCPxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:53:20 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432FAC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 08:53:20 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id h21so22161871qtp.11
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LueLWi18o8TNnEzdwPUl3xnfCFoirmw1KaO/TC2UH2c=;
        b=Glfy+unAV7H4ndNMVmB3w5QK5i7A6ZAyzYmRmT1AKvm+ESo0HrKGw7jLKM3NcuLC52
         xgPmX9erJU44yk84KtSkRTSh4MUopqjcp7ihfMBHY1OMrTr3P12ykK5ew0YPbOHJ3pzF
         trC58nYKxuAKGumfinuPuOEywiiRKSBxBPPkQgoa3WPLGE75+i3ZeQWd3gAEl0vwwG7+
         GpGqtr8VLxpfc6ywDQ+CmRGzh++pnwtLMRX5Pnaxhcu4fwvxzUdIOaXZ2dCkSbNQhD/v
         NCuXY1srf57EAafNFhAgu5vyRgyvaAvMt7v75gHfOK4nmf2HXApPzddJhBPVISkKjuHP
         a+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LueLWi18o8TNnEzdwPUl3xnfCFoirmw1KaO/TC2UH2c=;
        b=I80dmInph5ZBT6IeDle6ZTTpIVyk8z2XBRvG7cKCJZBVt4YMonRGXlf2c7KFKI4bCj
         BHpUS+SKLfoGOj2gBAfdQjRKoZXLzNC139kMq39fSFNTNagzX8sHgZGe9qPo9oslIYBp
         kTREqXo/D44YFXl6+QufzChtYKN6kLeuKCufrrCJjS61GlUsQDVrnviXZpeoAVQgcWVG
         U9uAfHEopFnyJmHkBFcD//RxBqx8E+4us4tGX4Z4O+INzB5Jt9wXyCmJuFojW3wKzQUt
         RunrZZ/ENKscFOCp5pPX7/yQzraHofEOdclYFCrqXUeD2WaaQBymqIgBe5YV2lH4J6q/
         ZBVw==
X-Gm-Message-State: AOAM532n0nwfmT7JO5nE999DsydbK1fzjEfY2d52W9cSr3ZYfs5yDKuD
        DejZpPoDlf58qBag+2Wr6HtAep+d
X-Google-Smtp-Source: ABdhPJyH5LVm+k/BCPn8C9RY+atLD/+GIsEp5ugAWL0srlni6GVhgcc4kwNuaO6ynv+EQ2+tb9dnew==
X-Received: by 2002:ac8:1e0e:: with SMTP id n14mr16937453qtl.109.1596469998253;
        Mon, 03 Aug 2020 08:53:18 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:989f:23de:f9a0:6da? ([2601:284:8202:10b0:989f:23de:f9a0:6da])
        by smtp.googlemail.com with ESMTPSA id y3sm22794170qtj.55.2020.08.03.08.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 08:53:17 -0700 (PDT)
Subject: Re: [iproute2-next v2 5/5] devlink: support setting the overwrite
 mask
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-6-jacob.e.keller@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0bb895a2-e233-0426-3e48-d8422fa5b7cf@gmail.com>
Date:   Mon, 3 Aug 2020 09:53:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200801002159.3300425-6-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 6:21 PM, Jacob Keller wrote:
> Add support for specifying the overwrite sections to allow in the flash
> update command. This is done by adding a new "overwrite" option which
> can take either "settings" or "identifiers" passing the overwrite mode
> multiple times will combine the fields using bitwise-OR.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  devlink/devlink.c | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
> 

5/5? I only see 2 - 4/5 and 5/5. Please re-send against latest
iproute2-next.

