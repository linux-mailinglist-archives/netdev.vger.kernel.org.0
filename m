Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924744D7A79
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 06:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbiCNFq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 01:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiCNFqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 01:46:55 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C263FBF5
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 22:45:46 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id w2so8147665oie.2
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 22:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=KVhbYFHGqvjj7PkfcwFkYVqX+xBelABPf+oZxs3rLEk=;
        b=PJFhIEuGRaMinMhQylXnawim1iO4XXTqV04M5WsrOwUzqZ0XiO48ITp/3G5mMECz/H
         dS3FYCPz6lfmrdICOJQACi2A1vTPX7/fa+tD8lqA43aqHRhzMOP7vjbQ1E53IPD5mA81
         yzhNmb73TFg0GJsO0kpFl22B8/n8e7lXcUY8lOdCJOojDgCdcGafEoIJ+uIjcrfExFWz
         golWvj313cScKQH25SEPxBp8zQRbh+IUFF3nc/LEbgT34OSpPrAOPj4gUVmcBOmWXXvz
         +5ltDxlkqoMygOYVJ/hmZf/PM8kCr6QaS1c8mIRKc887yc50Fc/MznkeC7xVW02e4LNo
         Rx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=KVhbYFHGqvjj7PkfcwFkYVqX+xBelABPf+oZxs3rLEk=;
        b=rGUyxcI6n/fZ3PjKQ+2Xpi+ki8pQa3OKObuHJ6QO4CwFQehoekukgZTuEygGruXlHw
         x7v/xg7O9BuUZJ0q87quBTPDRE+gwui2zjVRBnWoF5ZaBAV5MABh3HCGhqe0hFXnX+NR
         O6pJ88+5mGvr3Wi5C+EvvJYUyDLfaM+GqaLTfJFAwo+SqDJfauAXpdhvhNcfxUQCh40G
         CnxhP9C42UGsQuZ2mh5YNcDbocfHctCvfxi9xMZ0y2MQNYsgr33af1s6h/ruDFnTYiIc
         /4EP+je0fHqLiT7+wwq3l0Oq6CYmnLO7rcy1NzrmBstTx1RqusjMi0apOAn2nLbvpahE
         gUYw==
X-Gm-Message-State: AOAM530a48Jt+gT5tBAHmN/a3nHoIzv+Fiv+Tm4hpN/FCt2IGgmT4luz
        TdC+Ns+BoStDIf12aE+us9lUiROBCjG8SNfCzxo=
X-Google-Smtp-Source: ABdhPJxjk8b2QkwtTRDj5vbN6E99dViGK+nXf8Zr6AkfW6i4na3xT2JFJmf6sHti0M/fZS30MTSPDmJYFnHNB2iE2To=
X-Received: by 2002:aca:1303:0:b0:2ec:cae7:acc4 with SMTP id
 e3-20020aca1303000000b002eccae7acc4mr3891703oii.179.1647236308925; Sun, 13
 Mar 2022 22:38:28 -0700 (PDT)
MIME-Version: 1.0
Reply-To: issayacouba2021@gmail.com
Sender: mrs.awabello305@gmail.com
Received: by 2002:a4a:e1bb:0:0:0:0:0 with HTTP; Sun, 13 Mar 2022 22:38:28
 -0700 (PDT)
From:   issa <issayacouba2021@gmail.com>
Date:   Mon, 14 Mar 2022 06:38:28 +0100
X-Google-Sender-Auth: aWeQFwic702-NwumBL3sV4XmAaI
Message-ID: <CAJpGuB_gjCH1Kx01h+sbv3MhER3XAuebErXgUhhxGf6F1QkrTw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,HK_SCAM,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Old Friend
I'm happy to inform you about my success in getting those funds
transferred under the co operation of a new partner from Paraguay.
Presently I'm in Paraguay for investment projects with my own share of
the total sum. Meanwhile, I didn't forget your past efforts and
attempts to assist me in transferring those funds despite that you
failed to assist me financially.

Now contacts my secretary his name is Mr. Issa Yacouba; and ask him to
send you the total sum of $2, 000,000.00 U.S.D. which I kept for your
compensation for all the past efforts and attempts to assist me in
this matter.

With best regard
MR.RONNY ARMAND
