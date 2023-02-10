Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41E2692662
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbjBJTbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbjBJTbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:31:03 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F5363109;
        Fri, 10 Feb 2023 11:31:02 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id w11so9820900lfu.11;
        Fri, 10 Feb 2023 11:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5C6jWSG7hq9AtkVnw1BXnvg3J5xq2JBvsoPY4R7oHXU=;
        b=gMD70Aegzbk2FJrljWXL8n4WR1uQDyrvje9tkioETRW4JCRv90x2oO94HOHIvu2Z06
         o0MxG2ilUecybWXHL+d+Xmdmxyv0+QD9yQhz1v5xPMHA85aAlTx6+tfw068ixvNHRSoX
         qOca5+cXa9PT1aSDbwEPLvzjt66wedkDcpBuRfdHAnkCGxmUAOWGqPdf5AdjaiSsOeO8
         dTcPkkAMCjvcfkJoeGBkXHoIer2FQcsX8bMFHhHRRImaEAczYswqnA6QKDYom8ymjhjB
         aIMZQn3gJ4fRvnYMxTKydVhHZC0yeQ3NJEauTuVmMnb+DfkAR/3avFCOIfQ9qWbWhHmR
         IhIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5C6jWSG7hq9AtkVnw1BXnvg3J5xq2JBvsoPY4R7oHXU=;
        b=SJL/E5LXBL5zm1Ze0ULeU5acgUQDuFrZsvW8zehci/ho0Bk5NWe2F3uTu8xcTLmUAj
         pC0Y5k/pSPgrGLbvvqQ9tTzqoxTX7Sd7UfuJjbhv7ee0NIBeThjM2Fvw99JO1pKV9xu4
         IP7q6SIptK90pqgWFghXzMcmo0bwuC7jZqTIh9bkkpPuMzwp9la2wiQ1tWpNdXxqkYPh
         O/IO0R5tehjLs1CpAZR+oqAuDnkZ+7BtQeytogTBkNFh706ZabXoJ9gLR2Cz9qwtHRys
         Yj7BC2fym/rXTozN1G+mUiS+ZAATC/S2lbtUG2l2ZGD+Jt7wxjvfti8QLFDJcTDltwws
         z8VQ==
X-Gm-Message-State: AO0yUKUlg6dryrgg9al4MLU4CfjqoLm2fcQpVog+ifpckQtTO9zM+azC
        ckfCE6IEeHc2Bm8mtbhBUKtO+CcQTOukLudfsYA=
X-Google-Smtp-Source: AK7set/RRDSxCD8sl/9EyIJIc1+A4typ3xxXNp0BZ0jWrR//ggp3m+w5watXBqKJ/AgEOq7rY/x0crMIEI2RldJOeXA=
X-Received: by 2002:ac2:54af:0:b0:4bb:35c9:dfb5 with SMTP id
 w15-20020ac254af000000b004bb35c9dfb5mr2670374lfk.13.1676057460316; Fri, 10
 Feb 2023 11:31:00 -0800 (PST)
MIME-Version: 1.0
References: <20230126074356.431306-1-francesco@dolcini.it> <Y+YC3Pka42SmtyvI@francesco-nb.int.toradex.com>
 <CABBYNZLNFFUeZ1cb9xABhaymWnSiZjazwVT9N12qHyc7e0L6QQ@mail.gmail.com> <Y+aVQ38sJvuUd4HM@francesco-nb.int.toradex.com>
In-Reply-To: <Y+aVQ38sJvuUd4HM@francesco-nb.int.toradex.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 10 Feb 2023 11:30:48 -0800
Message-ID: <CABBYNZL7aD51jW=UxvcMBvfxbgFZ17H5nhfQ174JJNWDSdWe2A@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Bluetooth: hci_mrvl: Add serdev support for 88W8997
To:     Francesco Dolcini <francesco@dolcini.it>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Francesco,

On Fri, Feb 10, 2023 at 11:04 AM Francesco Dolcini <francesco@dolcini.it> wrote:
>
> On Fri, Feb 10, 2023 at 10:52:43AM -0800, Luiz Augusto von Dentz wrote:
> > Hi Francesco,
> >
> > On Fri, Feb 10, 2023 at 12:40 AM Francesco Dolcini <francesco@dolcini.it> wrote:
> > >
> > > Hello all,
> > >
> > > On Thu, Jan 26, 2023 at 08:43:51AM +0100, Francesco Dolcini wrote:
> > > > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > >
> > > > Add serdev support for the 88W8997 from NXP (previously Marvell). It includes
> > > > support for changing the baud rate. The command to change the baud rate is
> > > > taken from the user manual UM11483 Rev. 9 in section 7 (Bring-up of Bluetooth
> > > > interfaces) from NXP.
> > >
> > > Just a gently ping on this series, patches 1,2 with DT binding changes
> > > are reviewed/acked, patch 5 with the DTS change should just be on hold
> > > till patches 1-4 are merged.
> > >
> > > No feedback on patches 4 (and 3), with the BT serdev driver code
> > > changes, any plan on those?
> >
> > bots have detected errors on these changes
>
> From what I can understand from this point of view v2 is fine, the error
> was in v1, if I'm wrong just let me know.
>
> Said that I'll do the change you asked regarding __hci_cmd_sync_status
> and send a v3.

Great, for some reason your set is not being tested by our CI though,
@Tedd Ho-Jeong An do you know why?

> Thanks,
> Francesco
>


-- 
Luiz Augusto von Dentz
