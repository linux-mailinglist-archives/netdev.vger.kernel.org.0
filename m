Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2686D264394
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbgIJKQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730260AbgIJKQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 06:16:38 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656B6C061756;
        Thu, 10 Sep 2020 03:16:38 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id s13so5065195wmh.4;
        Thu, 10 Sep 2020 03:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DqY3ytm1lW24L4dBr5ZhfVe1Kl4JG7b6aElJixa0DtQ=;
        b=TyMbFj/CCKS/yEhzmJyx0SXASPCumWs129eaMWwliNPHoe9nGlJZk2Tsw17ABtL/mL
         mWke72l5dRMmrFg9ieYmDr1jVfXiMwSmIMEMsNuXAYrMDmbRSlu2SEhpSFeukLVe3cg9
         +5O+wBu+Jx7JfEyF9JNwdrWebHIVozT6N0VTqxSNEjrIsLOZ3R3dejl3APk21PLF2Oj8
         +Kb8ACZuKGttnfzoDexc2yloyF3/YUcCQzcDsr90PZvO0KOXZEocClY8eSC4NnFPV4xO
         lvhsU6vpfnm+pvKWrckJN/8r5bLtL/kaV4lfgkeSIGRnLzVQeQ+BBL7u23nOrwhO07G+
         JHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DqY3ytm1lW24L4dBr5ZhfVe1Kl4JG7b6aElJixa0DtQ=;
        b=pmUw8PMCpmIHzSROi++DPz4KjuYgWtg1+Y5TE231Bqiqr8R2N1C3xqoxsiwBj6o1cg
         uH2BXtjGnMGGoluHj644z5xr7xlqF6U2gftY836V0P2i1eGVJRbd6Kt5NRdxnuMIEUiL
         l2iyGGPzmqplYZFS9cH521ZnO3ebnALHjbVC/Yy86VDwVom/j1SkB7EzjdV3z887JSV1
         vBn2sxOKogw/Qr4Wwks6/Tsd6y+ZPpXYP0rtp5M7H0Cz9R+tTExVNwpFLc4afNM8kBHv
         sPRTlUxnMhVTJVsmuIxtZtgT2oyddp39osiyXrTv8c0GKDU7rTuLb07sCHlL7FBgK0nz
         qKBw==
X-Gm-Message-State: AOAM531fehkY9RO3xn+p429hIZbAH2vvrEoH04VI6Oae8Aw4ljanDWzg
        xuso8Ww0yrtKmBUnjJW0R1g=
X-Google-Smtp-Source: ABdhPJxz+CTfYBRsr9wPZ8ehDJQEmTq++yYJr4Xo0s0U0R6hQKoUpOmBLcC8LM7TIOPThVoU3WYKbg==
X-Received: by 2002:a1c:234b:: with SMTP id j72mr7837172wmj.153.1599732997083;
        Thu, 10 Sep 2020 03:16:37 -0700 (PDT)
Received: from ziggy.stardust ([213.195.113.201])
        by smtp.gmail.com with ESMTPSA id a127sm2936155wmh.34.2020.09.10.03.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 03:16:36 -0700 (PDT)
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
To:     Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>
Cc:     linux-wireless@vger.kernel.org, linux-fbdev@vger.kernel.org,
        oss-drivers@netronome.com, nouveau@lists.freedesktop.org,
        alsa-devel <alsa-devel@alsa-project.org>,
        dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org,
        dm-devel@redhat.com, linux-mtd@lists.infradead.org,
        linux-i2c@vger.kernel.org, sparclinux@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-rtc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        dccp@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net,
        linux-afs@lists.infradead.org, coreteam@netfilter.org,
        intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kees Cook <kees.cook@canonical.com>,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-sctp@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
        storagedev@microchip.com, ceph-devel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-mips@vger.kernel.org, iommu@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org,
        bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <81d852d4-115f-c6c6-ef80-17c47ec4849a@gmail.com>
Date:   Thu, 10 Sep 2020 12:16:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/09/2020 22:06, Joe Perches wrote:
> diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
> index 09f931d4598c..778be26d329f 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/dma.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
> @@ -193,11 +193,11 @@ static void mt7601u_complete_rx(struct urb *urb)
>   	case -ESHUTDOWN:
>   	case -ENOENT:
>   		return;
> +	case 0:
> +		break;
>   	default:
>   		dev_err_ratelimited(dev->dev, "rx urb failed: %d\n",
>   				    urb->status);
> -		fallthrough;
> -	case 0:
>   		break;
>   	}
>   
> @@ -238,11 +238,11 @@ static void mt7601u_complete_tx(struct urb *urb)
>   	case -ESHUTDOWN:
>   	case -ENOENT:
>   		return;
> +	case 0:
> +		break;
>   	default:
>   		dev_err_ratelimited(dev->dev, "tx urb failed: %d\n",
>   				    urb->status);
> -		fallthrough;
> -	case 0:
>   		break;
>   	}

Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
