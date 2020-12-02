Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DD42CC984
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgLBWU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgLBWU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:20:26 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CDCC061A47;
        Wed,  2 Dec 2020 14:19:39 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id s30so7236669lfc.4;
        Wed, 02 Dec 2020 14:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EIruGRd4mugAkAFXMPG5djeoGY4ogM1hgJDgqpib//o=;
        b=svXD3R/pbQ6J9th26y4lpPOmwEM9/0s/xp218p7FiAHnwYWWXxaEqeCEZE3QPcOD/P
         gv3p0+td2N3+kOapYmKu1ryt053ELTkOvg+mlxe5l4k03T5A1pIHhQhnqfgJYzOcnIvm
         mk8eme3KuOw3OSk9yNjihGfjaDahcM2Vnm3jeJqiQlkVdI8NWi7bHr9SXOk/bcqvjw71
         GkC6G9LoTKtAc/MOy0oDEPJOKjGdhwOD2VwxOjIi1U0FjOUFRSPo/YfOpR5ehfG+QVfZ
         V5BWLP+Iof+5B8nxIZvpxOx4C43W8YqY44RIogxIUkWExGKqPwnkilcqOf6Y569+/zRt
         oiWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EIruGRd4mugAkAFXMPG5djeoGY4ogM1hgJDgqpib//o=;
        b=cNyodGNSYgTVCq7JUnSNUaUQs6U8xwSa7b/dwdPki1Qcb4VYf/lRWNXGpodLCcrV6c
         DPTO76hJu9x8tZDedl26IPasVczHFyjzo08kDEufK4hNat8SCeJtA8UkWzNi1A9EUkbr
         8i5+w5Fsn/0I8N5MvWAtUQE5pjKZ/Q0DOHp0ISURZysbihHhyC47GOzkSgzo3Wts4dfE
         JoRQroU4p22zEYLQd3GQbtUhzAacHKWSU9gkGZkDd9yzKlwiK2IQv+cfudzQS7pOP+5Z
         7A7eJIb6t2D9UW8IsT7uKC5TtX+UiNTkOuAC+rwfCZZLpV8pWQUh+ISFPO4y4yNeUsIu
         xeRA==
X-Gm-Message-State: AOAM530/qfw2OvCzutNUiIwIfcPgcl2hovpEyL15Z7LV1lfT73czZYiw
        OY75ZBlMqjczulAt7yXhu0efbtL0sI+RDYUAz4pVpC/K
X-Google-Smtp-Source: ABdhPJwiIZjEuef9Wjfsp+m4vlUrAjDPdAzP3NvFPlL1p9wwwRbQmbUZEUu6Lxa6iSLes34IFLhCOeElmzUI2n2Zg4U=
X-Received: by 2002:ac2:5e91:: with SMTP id b17mr84979lfq.442.1606947541002;
 Wed, 02 Dec 2020 14:19:01 -0800 (PST)
MIME-Version: 1.0
References: <5fc100ec.1c69fb81.58b7b.2dee@mx.google.com> <20201130184845.304f54d3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130184845.304f54d3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Thu, 3 Dec 2020 07:18:49 +0900
Message-ID: <CACwDmQCvB0WSQ86igZXT9FAihqGbM4THXWXj-jRAzr6EhSDf7g@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net/nfc/nci: Support NCI 2.x initial sequence
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-nfc@lists.01.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 11:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 27 Nov 2020 22:36:31 +0900 bongsu.jeon2@gmail.com wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > implement the NCI 2.x initial sequence to support NCI 2.x NFCC.
> > Since NCI 2.0, CORE_RESET and CORE_INIT sequence have been changed.
> > If NFCEE supports NCI 2.x, then NCI 2.x initial sequence will work.
> >
> > In NCI 1.0, Initial sequence and payloads are as below:
> > (DH)                     (NFCC)
> >  |  -- CORE_RESET_CMD --> |
> >  |  <-- CORE_RESET_RSP -- |
> >  |  -- CORE_INIT_CMD -->  |
> >  |  <-- CORE_INIT_RSP --  |
> >  CORE_RESET_RSP payloads are Status, NCI version, Configuration Status.
> >  CORE_INIT_CMD payloads are empty.
> >  CORE_INIT_RSP payloads are Status, NFCC Features,
> >     Number of Supported RF Interfaces, Supported RF Interface,
> >     Max Logical Connections, Max Routing table Size,
> >     Max Control Packet Payload Size, Max Size for Large Parameters,
> >     Manufacturer ID, Manufacturer Specific Information.
> >
> > In NCI 2.0, Initial Sequence and Parameters are as below:
> > (DH)                     (NFCC)
> >  |  -- CORE_RESET_CMD --> |
> >  |  <-- CORE_RESET_RSP -- |
> >  |  <-- CORE_RESET_NTF -- |
> >  |  -- CORE_INIT_CMD -->  |
> >  |  <-- CORE_INIT_RSP --  |
> >  CORE_RESET_RSP payloads are Status.
> >  CORE_RESET_NTF payloads are Reset Trigger,
> >     Configuration Status, NCI Version, Manufacturer ID,
> >     Manufacturer Specific Information Length,
> >     Manufacturer Specific Information.
> >  CORE_INIT_CMD payloads are Feature1, Feature2.
> >  CORE_INIT_RSP payloads are Status, NFCC Features,
> >     Max Logical Connections, Max Routing Table Size,
> >     Max Control Packet Payload Size,
> >     Max Data Packet Payload Size of the Static HCI Connection,
> >     Number of Credits of the Static HCI Connection,
> >     Max NFC-V RF Frame Size, Number of Supported RF Interfaces,
> >     Supported RF Interfaces.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
>
> >  static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
> >  {
> > -     nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
> > +     struct nci_core_init_v2_cmd *cmd = (struct nci_core_init_v2_cmd *)opt;
> > +
> > +     if (!cmd)
> > +             nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
> > +     else
> > +             /* if nci version is 2.0, then use the feature parameters */
> > +             nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD,
> > +                          sizeof(struct nci_core_init_v2_cmd), cmd);
>
> This would be better written as:
>
>         u8 plen = 0;
>
>         if (opt)
>                 plen = sizeof(struct nci_core_init_v2_cmd);
>
>         nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, plen, (void *)opt);
>
> > +
>
> unnecessary empty line
>
> >  }
> >
> >  static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
> > @@ -497,8 +505,18 @@ static int nci_open_device(struct nci_dev *ndev)
> >       }
> >
> >       if (!rc) {
> > -             rc = __nci_request(ndev, nci_init_req, 0,
> > -                                msecs_to_jiffies(NCI_INIT_TIMEOUT));
> > +             if (!(ndev->nci_ver & NCI_VER_2_MASK)) {
> > +                     rc = __nci_request(ndev, nci_init_req, 0,
> > +                                        msecs_to_jiffies(NCI_INIT_TIMEOUT));
> > +             } else {
> > +                     struct nci_core_init_v2_cmd nci_init_v2_cmd;
> > +
> > +                     nci_init_v2_cmd.feature1 = NCI_FEATURE_DISABLE;
> > +                     nci_init_v2_cmd.feature2 = NCI_FEATURE_DISABLE;
> > +
> > +                     rc = __nci_request(ndev, nci_init_req, (unsigned long)&nci_init_v2_cmd,
> > +                                        msecs_to_jiffies(NCI_INIT_TIMEOUT));
> > +             }
>
> again please try to pull out the common code:
>
>         struct nci_core_init_v2_cmd nci_init_v2_cmd = {
>                 .feature1 = NCI_FEATURE_DISABLE;
>                 .feature2 = NCI_FEATURE_DISABLE;
>         };
>         unsigned long opt = 0;
>
>         if (ndev->nci_ver & NCI_VER_2_MASK)
>                 opt = (unsigned long)&nci_init_v2_cmd;
>
>         rc = __nci_request(ndev, nci_init_req, opt,
>                            msecs_to_jiffies(NCI_INIT_TIMEOUT));
>
>
> >       }
>
> > -static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
> > +static unsigned char nci_core_init_rsp_packet_v1(struct nci_dev *ndev, struct sk_buff *skb)
> >  {
> >       struct nci_core_init_rsp_1 *rsp_1 = (void *) skb->data;
> >       struct nci_core_init_rsp_2 *rsp_2;
> > @@ -48,16 +51,14 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
> >       pr_debug("status 0x%x\n", rsp_1->status);
> >
> >       if (rsp_1->status != NCI_STATUS_OK)
> > -             goto exit;
> > +             return rsp_1->status;
> >
> >       ndev->nfcc_features = __le32_to_cpu(rsp_1->nfcc_features);
> >       ndev->num_supported_rf_interfaces = rsp_1->num_supported_rf_interfaces;
> >
> > -     if (ndev->num_supported_rf_interfaces >
> > -         NCI_MAX_SUPPORTED_RF_INTERFACES) {
> > -             ndev->num_supported_rf_interfaces =
> > -                     NCI_MAX_SUPPORTED_RF_INTERFACES;
> > -     }
> > +     ndev->num_supported_rf_interfaces =
> > +             min((int)ndev->num_supported_rf_interfaces,
> > +                 NCI_MAX_SUPPORTED_RF_INTERFACES);
> >
> >       memcpy(ndev->supported_rf_interfaces,
> >              rsp_1->supported_rf_interfaces,
> > @@ -77,6 +78,58 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
> >       ndev->manufact_specific_info =
> >               __le32_to_cpu(rsp_2->manufact_specific_info);
> >
> > +     return NCI_STATUS_OK;
> > +}
> > +
> > +static unsigned char nci_core_init_rsp_packet_v2(struct nci_dev *ndev, struct sk_buff *skb)
> > +{
> > +     struct nci_core_init_rsp_nci_ver2 *rsp = (void *)skb->data;
> > +     unsigned char rf_interface_idx = 0;
>
> Prefer the use of u8 type in the kernel
>
> > +     unsigned char rf_extension_cnt = 0;
> > +     unsigned char *supported_rf_interface = rsp->supported_rf_interfaces;
>
> Please order the variable declarations longest to shortest.
> Don't initialize them inline if that'd cause the order to break.
>
> > +     pr_debug("status %x\n", rsp->status);
> > +
> > +     if (rsp->status != NCI_STATUS_OK)
> > +             return rsp->status;
> > +

Thank you for your advice.
I will send a new version.
