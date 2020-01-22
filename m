Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6DD145C68
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgAVT2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:28:08 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52535 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVT2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 14:28:08 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so292311wmc.2
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 11:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=594SaYv3888APNQ820Q9JWmvGeC6Tc3X4XEAPk2qpQI=;
        b=YZ8WkQVGgCas81SfxTvfaziMXjozYi2gA1tIuLi22q0TiMpXXQlc2ip4fw7hFQwI1f
         8pY6LRw+nkFMaaIBGewAr/dkYfaArovoEQli8DPjk+oAQXzwRRS65ljG0Bjqa3deA/pJ
         TpN7BzD/VtX6ndPnLCVhQl3JmGSQI8U7Nrz3nFmaW+NgljAHEhnsovx8wd3+LUQDIwu1
         ACEN4m/TqTWQlNhVWFOhoeveUeEVF1WXuTjHpB82WMx1k5qEOqTMCb8Dy78qG46NaiJx
         rLRLd6c8EngrhoCIqCsQXA7RbOXgp5NfyDCXQpKi5h3pvAKEwAXc4wVgIhcwfpOiGKbF
         q0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=594SaYv3888APNQ820Q9JWmvGeC6Tc3X4XEAPk2qpQI=;
        b=NryHqIkcJnA+680OnX7Q9+YFjiY63JrCkxkexEgMvMaMQzRZEGMvvUYql5moo95aYH
         teSG3rEfas0c0TpgseokU/g/ZQ8r0Y84MCjJu3aBkRSQzcRKalxCQhVrkimJM6O5yVfX
         eG5FM4Pd8SYCoYa7sBUCTdACSBSEe/P/DI82NH0ems1qgdB6sDUjSDUUIlTubn026uVc
         UPVf4btxkf7akq1oTBU3Y8CFRaqgiCzc30B4ihKCUEjIp/Rrpw/Ymacen58lcmKPH5Vh
         E1fSpcYBJEKAENkemU+9/2VK2W8vUjS1MZe+nM3Unpcrel550kODwIljToDDWT2w3Epj
         W2wQ==
X-Gm-Message-State: APjAAAVDc5ZD3z4OOPQ9sGdzPhkOT/QlkJ+s0fSZfZ/IHb15lN+vJgiP
        9CWrHfxPfPdXlj7oz4+NZDmwh5nlYxZ+rUFOiq0=
X-Google-Smtp-Source: APXvYqzAShMrta66y2UH+fBpJBG+4ND6sdSgpAflNrpOjyo45zeQCr1tIwU9bAhP3YAqwlfO3BdD3fjAVcRs9JgBbjA=
X-Received: by 2002:a05:600c:244:: with SMTP id 4mr4670609wmj.40.1579721286338;
 Wed, 22 Jan 2020 11:28:06 -0800 (PST)
MIME-Version: 1.0
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579612911-24497-4-git-send-email-sunil.kovvuri@gmail.com> <20200121080038.0fe6a819@cakuba>
In-Reply-To: <20200121080038.0fe6a819@cakuba>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 23 Jan 2020 00:57:55 +0530
Message-ID: <CA+sq2CfZSfSvJvekfiRgQ-P5xjF6B=7kOHGXhUPe7fk2Fb_57Q@mail.gmail.com>
Subject: Re: [PATCH v4 03/17] octeontx2-pf: Attach NIX and NPA block LFs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 9:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 21 Jan 2020 18:51:37 +0530, sunil.kovvuri@gmail.com wrote:
> > +int otx2_config_npa(struct otx2_nic *pfvf)
> > +{
> > +     struct otx2_qset *qset = &pfvf->qset;
> > +     struct npa_lf_alloc_req  *npalf;
> > +     struct otx2_hw *hw = &pfvf->hw;
> > +     int aura_cnt, err;
> > +
> > +     /* Pool - Stack of free buffer pointers
> > +      * Aura - Alloc/frees pointers from/to pool for NIX DMA.
> > +      */
> > +
> > +     if (!hw->pool_cnt)
> > +             return -EINVAL;
> > +
> > +     qset->pool = devm_kzalloc(pfvf->dev, sizeof(struct otx2_pool) *
> > +                               hw->pool_cnt, GFP_KERNEL);
> > +     if (!qset->pool)
> > +             return -ENOMEM;
> > +
> > +     /* Get memory to put this msg */
> > +     npalf = otx2_mbox_alloc_msg_npa_lf_alloc(&pfvf->mbox);
> > +     if (!npalf)
> > +             return -ENOMEM;
> > +
> > +     /* Set aura and pool counts */
> > +     npalf->nr_pools = hw->pool_cnt;
> > +     aura_cnt = ilog2(roundup_pow_of_two(hw->pool_cnt));
> > +     npalf->aura_sz = (aura_cnt >= ilog2(128)) ? (aura_cnt - 6) : 1;
> > +
> > +     err = otx2_sync_mbox_msg(&pfvf->mbox);
> > +     if (err)
> > +             return err;
> > +     return 0;
>
> return otx2_sync..
>
> directly
>
> > +}
>
> > +static int otx2_realloc_msix_vectors(struct otx2_nic *pf)
> > +{
> > +     struct otx2_hw *hw = &pf->hw;
> > +     int num_vec, err;
> > +
> > +     /* NPA interrupts are inot registered, so alloc only
> > +      * upto NIX vector offset.
> > +      */
> > +     num_vec = hw->nix_msixoff;
> > +#define NIX_LF_CINT_VEC_START                        0x40
> > +     num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
> > +
> > +     otx2_disable_mbox_intr(pf);
> > +     pci_free_irq_vectors(hw->pdev);
> > +     pci_free_irq_vectors(hw->pdev);
> > +     err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
> > +     if (err < 0) {
> > +             dev_err(pf->dev, "%s: Failed to realloc %d IRQ vectors\n",
> > +                     __func__, num_vec);
> > +             return err;
> > +     }
> > +
> > +     err = otx2_register_mbox_intr(pf, false);
> > +     if (err)
> > +             return err;
> > +     return 0;
> > +}
>
> ditto, please fix this everywhere in the submission

Thanks, will fix and resubmit.

Sunil.
