Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3486488FFE
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbiAJGFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:05:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238910AbiAJGF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:05:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641794725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8B9v5zsulee4JWEx0ZfQ15LgjWMOgl5F3Wosda3R7Wk=;
        b=OBm+c+F0Pgd5yhhFEuQOok9jLbq8fzW/6rFqKdumP+i2q2DEObsTHrcRf94S4uk+Wr410l
        URSEifDZ1pXlJWKxpR8iptOEI7ePVbupDh5QDexD7W/A12vL/Lv1LUZnEqVdyba3W6IQju
        m9jvEBovBORSWQAJZWF+tJ5Ckzm+5mI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-ud9vqqWfOwi2y2ph7rsnEQ-1; Mon, 10 Jan 2022 01:05:19 -0500
X-MC-Unique: ud9vqqWfOwi2y2ph7rsnEQ-1
Received: by mail-wm1-f70.google.com with SMTP id o18-20020a05600c511200b00345c1603997so2053818wms.1
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 22:05:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8B9v5zsulee4JWEx0ZfQ15LgjWMOgl5F3Wosda3R7Wk=;
        b=11ceTTj360fjRm6Pjx6KU12VLw1+9w/Z93bGhAjJI2Urq0CRPP8JPwe3piLC72JtEV
         VaZsyb5qDoeL5Qb6ptRO6HjNCQUAxSH5FSowmef7qJrBlEIbq3Koe9EFSZTg+70KGsJa
         X4+EQGTfnbRxDQn07tOaxMUUs1GZl9KLJugGDhnbG5ety5Olpq9nce21zQEYfAf2BIew
         4Sz8x4T8rtMPWR53PEFer6t2h3mol/1mi8lpGiMGbVszU0SbocYTmoF8eX+SjJK1tJEN
         VftzyszrcgWvNGBMfRqichkYZJauAARZUpT2XDig49erQapo1nWtMsWZjouaJFrqUNEQ
         mR2A==
X-Gm-Message-State: AOAM530Qn3jC4WlSwV2odHhZp5XfKohjoiYr54f+sNQqZRZ5Az2s4WSk
        BJv2n4zKVcyspw0fxlbFCb2B5VtbWPVPNlZxud+OUsmSudcSdCpUOTE3CL1hsEWbQz+Dh68LDjs
        t1aDS3HbjQT6316Gc
X-Received: by 2002:a05:6000:2a3:: with SMTP id l3mr61601970wry.289.1641794718017;
        Sun, 09 Jan 2022 22:05:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZ9hZPTAaz7Ugpm9hNLEvBTj7Xc7ppjExovkQuQO56o48Z51psEH23827LzrOjcFC1ym0Hug==
X-Received: by 2002:a05:6000:2a3:: with SMTP id l3mr61601960wry.289.1641794717876;
        Sun, 09 Jan 2022 22:05:17 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107d:b60c:c297:16fe:7528:e989])
        by smtp.gmail.com with ESMTPSA id n7sm5668831wms.46.2022.01.09.22.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 22:05:17 -0800 (PST)
Date:   Mon, 10 Jan 2022 01:05:14 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] Supoort shared irq for virtqueues
Message-ID: <20220110010441-mutt-send-email-mst@kernel.org>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110051851.84807-1-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 01:18:44PM +0800, Zhu Lingshan wrote:
> On some platforms, it has been observed that a device may fail to
> allocate enough MSI-X vectors, under such circumstances, the vqs have
> to share a irq/vector.
> 
> This series extends irq requester/handlers abilities to deal with:
> (granted nvectors, and max_intr = total vq number + 1(config interrupt) )
> 
> 1)nvectors = max_intr: each vq has its own vector/irq,
> config interrupt is enabled, normal case
> 2)max_intr > nvectors >= 2: vqs share one irq/vector, config interrupt is
> enabled
> 3)nvectors = 1, vqs share one irq/vector, config interrupt is disabled.
> Otherwise it fails.
> 
> This series also made necessary changes to irq cleaners and related
> helpers.
> 
> Pleaase help reivew.


A bunch of typos in commit logs, please spell-check them.

> Thanks!
> Zhu Lingshan
> 
> Zhu Lingshan (7):
>   vDPA/ifcvf: implement IO read/write helpers in the header file
>   vDPA/ifcvf: introduce new helpers to set config vector and vq vectors
>   vDPA/ifcvf: implement device MSIX vector allocation helper
>   vDPA/ifcvf: implement shared irq handlers for vqs
>   vDPA/ifcvf: irq request helpers for both shared and per_vq irq
>   vDPA/ifcvf: implement config interrupt request helper
>   vDPA/ifcvf: improve irq requester, to handle per_vq/shared/config irq
> 
>  drivers/vdpa/ifcvf/ifcvf_base.c |  65 ++++--------
>  drivers/vdpa/ifcvf/ifcvf_base.h |  45 +++++++-
>  drivers/vdpa/ifcvf/ifcvf_main.c | 179 +++++++++++++++++++++++++++-----
>  3 files changed, 215 insertions(+), 74 deletions(-)
> 
> -- 
> 2.27.0

