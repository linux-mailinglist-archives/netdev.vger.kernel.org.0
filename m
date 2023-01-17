Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDB266DD94
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 13:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbjAQM24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 07:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbjAQM2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 07:28:54 -0500
Received: from aib29gb127.yyz1.oracleemaildelivery.com (aib29gb127.yyz1.oracleemaildelivery.com [192.29.72.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46758367F5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 04:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rSfuiJxxoteBB8nWQz9EHh3tEZgaUdP09an5J6pNf38=;
 b=Ca+6e6eX/idiXFhgWkZ7D0GoBiwBySUcpRLuBgaSSf7WCNoIf93HVFyXs2rXrg79akmrx5hPgob8
   J4uo/G9z70lIKk5w03AJgW07l33g8cWFegZV45zqKh8AJA6vLeehyyAH0Uub3H+mqGAchJfrFORj
   jvH6vwLB2iidIf4eX6Fm09DdmRio+ARWKJjgMLejuf64irGwF7DAK1FXf+VjRhBRtk04SRZMJFEV
   3dj0hLWm5riaQfl1Uzor68T1zmDpeywDettrbkd4aoxw+b4zU3NkHmV2xgiBDIwYntL3urpFM8g3
   qOxrqmdExFI7DxTLM7fgicBY0H24TUpXb2ZnvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=rSfuiJxxoteBB8nWQz9EHh3tEZgaUdP09an5J6pNf38=;
 b=GZ7CnAVcXO/xzZb3LyWQTCFbbkqTNrLrZDZ/I3fePfWqk9SmeL67E2Wft45I8EiwQKT6Lm1Ff/ya
   EEkL6sCWlADcqYXncfvwy+ZFFx4lGAt5Ev5JEek1D1HtwgIkLUD21Px2iE2YJpR/iZ5KhXEVdWnu
   sjKbSgLAKQLebjvwg1e0LK/1PqsUgcVqYgfx8bK/7DEJ/d4nt+yifZ1RwhBLZWTr6FmeFJGPLSfW
   KPiof34RG2EJDvf4LK8u6kNtUSbcxSiUGlqzwUJYyOR4xb6mL4JcZqhsG68Kwt6HwcUtJhr1Xmso
   ksUe1XT6TXTMM+xG4C/M0m6YUza3a+JIRiPMRg==
Received: by omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROM00M7IQO383B0@omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 netdev@vger.kernel.org; Tue, 17 Jan 2023 12:28:51 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Peter Lafreniere <peter@n8pjl.ca>
Subject: Re: [PATCH] wifi: rsi: Avoid defines prefixed with CONFIG
Date:   Tue, 17 Jan 2023 07:28:38 -0500
Message-id: <20230117122838.5006-1-peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.0
In-reply-to: <87mt6h8xu7.fsf@kernel.org>
References: <87mt6h8xu7.fsf@kernel.org>
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAFB26/OsDs3HpaqMgyiQ+gVr10Eu3gsJyXSTiaqp0dYs2WEvkjae9Bo+cOYXsN/
 U1yayjDbJGkvjRRxA5O6uC24CUPlfHp7L48sYH/IZOgQseb7LqqY3j5vCCEqtiTH
 okImZMPPIHod9KCZQZ76eSbKD1xYq0q+Gue4iUSNkfFnMJEg9g60W/fLqAgeO0rt
 0gOk0wW+QSte9uO2SaCVwzXRkUGPBC1BdhFWlKr7PcTQxaxWYyrY7fpuZKrpYEQ1
 /hhM86jQUGZI2Q3Ev4nTp+QhLb+wIWkr4EBGJMdSDUOYOrmtYhNZ7TufDl6eUedn
 13BBpZUqXHtfKbrtorxEpaxKtB/fzrjD7qGiJjAiGWztLIkaFLuWQsEMwFLV5PjX
 XoMUGIkfuKn2LbgTzJYWoHeZ/pAOFkSEHyaplJR8I+6w9qAqzTBTnAUOLw==
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That would work better, but to me it seems odd to have one define
with a prefix and the others without. I could change them all, but
that seems like excessive churn for the very minor 'issue' that
it fixes.

After rereadig rsi_load_9113_firmware(), it seems like just dropping
the CONFIG_ would be a reasonable change that doesn't affect readability.

Cheers,
Peter
