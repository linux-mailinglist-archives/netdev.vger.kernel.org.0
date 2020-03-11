Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B8718118B
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 08:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgCKHON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 03:14:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46791 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKHON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 03:14:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id n15so1114200wrw.13
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 00:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GdrQKFWNObRYWnlNN4xqY6571q8C0DRBQeryc7PmYTA=;
        b=DQnl7Bhej1sYanUc3BDkhgYGBNET4v6dBoPHtwUxq0ivfdjxefc9WhVuQu/gEne3ep
         RnuhSEI1XANnzkFCINwFbJw/4lhwCzm2vP/eysGMs4bs+Fis8eVEpL74XEaWid2KSLMF
         r0GQNFPHus8bOedmo7KKh5ywHmaRivkYy+7vMFqddv45s3iwPWTWomLEEHu2Dc0M9CY0
         PE3jC2Szrsaboy8cN5LHlGU1L8Club9MQ5Saa8CGgj90ffkvV7uYpTQA2HOLX6CoYwxi
         13r6P9FUPA1ZKMwshBtRU/6EMBbwZtAllKwCTdEy61SA/emi7xF6/bmvuB+ASsS9j4PM
         NJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GdrQKFWNObRYWnlNN4xqY6571q8C0DRBQeryc7PmYTA=;
        b=o94+4ak5Irz6eArC7UHXuFpfeQkttf0UcbFhqv3aZtRmQ4gOP6mf27RaQ1C1Ez94Fs
         2eDHqboXio9fDQ+qhEw80P3Ahsf0grVweGxFi3HzF9Bbnh5CxPuxk1X3ERTxkuhmqn7V
         BlLJkJoBrLVkZdkPrbD29hAfVeZMQSg/733CuOaHHtrIA2yaRNWTjO9HWbuCvhsWuwv3
         DiH+fnZ7FllRsQZm68X8NF3+qsnfxmAVWDAPyDjl1VIq+BpFnozhWLkh7VBUmLnNkp9S
         yS2vfVcfLe334pTKw1xhIfENYF5wAXvpw7AX191j3A0jdqgixVX1x8FHeCXzzhl9KuNt
         G8lg==
X-Gm-Message-State: ANhLgQ2b13Q4FspuJdGraGR0Auk8j9jNn1gXEnDKezldj2vRRioYwvhA
        r60TrUhojuQjEpHOgF81aDbpGOcLkxXd4sDkUP8GkiHK
X-Google-Smtp-Source: ADFU+vuzrQEt4rGPICxOJ2LKUsq2YPfEfq8rfw8iAoTk5i7ASJ6oaAEClXqtl/n5GrwoE+YF0on2IeOMF1GVYTvhiTA=
X-Received: by 2002:adf:ea03:: with SMTP id q3mr2577794wrm.267.1583910851217;
 Wed, 11 Mar 2020 00:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
 <1583866045-7129-4-git-send-email-sunil.kovvuri@gmail.com> <20200310144320.4f691cb6@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200310144320.4f691cb6@kicinski-fedora-PC1C0HJN>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 11 Mar 2020 12:44:00 +0530
Message-ID: <CA+sq2Ce7OFeKXBc_hHWODGuhgfNmfhOanhW4uyr=GLxAwZUPKw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] octeontx2-vf: Virtual function driver dupport
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 3:13 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 11 Mar 2020 00:17:22 +0530 sunil.kovvuri@gmail.com wrote:
> > +#define DRV_NAME     "octeontx2-nicvf"
> > +#define DRV_STRING   "Marvell OcteonTX2 NIC Virtual Function Driver"
> > +#define DRV_VERSION  "1.0"
>
> Please drop the driver version, kernel version should be used upstream.
>

Okay, will do.

> > +
> > +static const struct pci_device_id otx2_vf_id_table[] = {
> > +     { PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_AFVF) },
> > +     { PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_VF) },
> > +     { }
> > +};
> > +
> > +MODULE_AUTHOR("Marvell International Ltd.");
>
> Only people can be authors, please put your name here or remove this.
>

Just for my understanding, is this due to a decision taken in netdev recently ?
I have searched through all drivers in netdev and there is a mix of
organizations and individuals as AUTHORS.
Here we used org name to avoid specifying multiple names.


> > +static netdev_tx_t otx2vf_xmit(struct sk_buff *skb, struct net_device *netdev)
> > +{
> > +     /* Check for minimum and maximum packet length */
> > +     if (skb->len <= ETH_HLEN ||
> > +         (!skb_shinfo(skb)->gso_size && skb->len > vf->max_frs)) {
>
> These should never happen (if they do we need to fix the stack, not
> sprinkle all the drivers with checks like this).
>

HW has limitation on minimum number of bytes being transmitted, hence the check.
Even i wasn't sure if it would be possible, but saw similar
limitation/checks in few other drivers, hence added.

Regarding maximum length check, i did see pkts with > MTU (when
pathMTU is considered).
But anyways due to changes patch6 of this series HW should shouldn't
complain, i will remove this.
Should have removed earlier itself, sorry for the trouble.

>
> > +static void otx2vf_reset_task(struct work_struct *work)
> > +{
> > +     struct otx2_nic *vf = container_of(work, struct otx2_nic, reset_task);
> > +
> > +     if (!netif_running(vf->netdev))
> > +             return;
> > +
> > +     otx2vf_stop(vf->netdev);
> > +     vf->reset_count++;
> > +     otx2vf_open(vf->netdev);
>
> What's the locking around here? Can user call open/stop while this is running?
>

Yes, possible, thanks, will fix.

> > +     netif_trans_update(vf->netdev);
> > +}
>
> > +static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
> > +{
> > +     struct otx2_hw *hw = &vf->hw;
> > +     int num_vec, err;
> > +
> > +     num_vec = hw->nix_msixoff;
> > +     num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
> > +
> > +     otx2vf_disable_mbox_intr(vf);
> > +     pci_free_irq_vectors(hw->pdev);
> > +     pci_free_irq_vectors(hw->pdev);
>
> Why free IRQs twice?
>

hmm.. will fix.

> > +     err = otx2vf_register_mbox_intr(vf, false);
> > +     if (err)
> > +             return err;
>
> return otx2vf_re..

Okay, will change.

Thanks,
Sunil.
