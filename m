Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3B34BF64E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiBVKmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiBVKmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:42:32 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FF2EDF0C
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:42:07 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id m11so11686832pls.5
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=orUonpmoNEKNmxUpRT7+mW8AVPFAeRC6Fgq/iIbRlnV9P0f10zMyraFydKHYaAJBbo
         umw+YPfTZ/6ivQ1Je7eYxBbYldnnCbfFf+tRLjqGB3mBEak7OUXg7xfKg6KPg3zrupf1
         ELV+vujQ+fMxnFs4fx48WuxHn1BLjdRahR8OJjKp1c84tf40Ae8+cslT+NyjBRJc2wCC
         GRbY4FROcmtI1/E741a19FkU/39sPhiC/DdYBGOM6KA5o36Yb9kJjKzO9QS3alduaJzM
         Wan7WiSV0PrXEB0cPfA0IWTR9siuCNUlBxHDjYpHb6aqDgzuYENB6pffDahioDKukfGc
         uBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=m4e3Q4zXwGM4NX4IUnXLJQp+DHTRwfE/F2uux33sYn4T/16vqin/hmTNa6I9G5vCxP
         rsXMM59Lk1CcFxxbF97cBXUSpahOlkWYHY25f/JcQM0BSfcc/vPHCHEDIKFIbvYsF9f0
         00/IBKy4t+/HXInhj6DHcpH5MLvQt454FaszpL+3vgJv1QpkQsUA5haT1WJa8P5Ts313
         nC1R0xI/bKB9VElmsjKNqIrKLfXuPCReEOpLLL53Ofe6pHn+yRaXRvbC1Fy8thUwh7Ue
         vxN+lW+WUqplVVVciNnbYyIaVkJN+7moyWcc0eEH/vljo4AVuomSyPmFIYsf21UMyEoW
         4ugQ==
X-Gm-Message-State: AOAM530e929fCXmlJ5txJp7CsX0WObo5GUxarJddAt//Kbi7VGdu4pcg
        04bt5iCH6PvTE7v9oduD15nmr4OirIB1iStZjak=
X-Google-Smtp-Source: ABdhPJx2lKcHTnu5kv0y34IUpPsqR2AU2wfPn/72KmMpbFIliWNHiASXFsYlGXnpEFZIpgOA/55jTJ+ArabWd5oOJ1o=
X-Received: by 2002:a17:903:22c3:b0:14f:c274:aa87 with SMTP id
 y3-20020a17090322c300b0014fc274aa87mr7265685plg.17.1645526527160; Tue, 22 Feb
 2022 02:42:07 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:bd09:0:0:0:0 with HTTP; Tue, 22 Feb 2022 02:42:06
 -0800 (PST)
Reply-To: davidnelson7702626@gmail.com
From:   Zekeriya Badou <zekeriyabadou@gmail.com>
Date:   Tue, 22 Feb 2022 11:42:06 +0100
Message-ID: <CAKgROLDRvx0Ogs24Nz9mJDPMHF+gTupYNYHZxXVeG4C3e0JRGA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello friend, I want to send money to you to enable me invest in your
country get back to me if you are interested.
