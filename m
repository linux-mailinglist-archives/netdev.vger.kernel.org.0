Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A1E14C9E3
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 12:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgA2LqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 06:46:11 -0500
Received: from sonic313-56.consmr.mail.ne1.yahoo.com ([66.163.185.31]:46096
        "EHLO sonic313-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbgA2LqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 06:46:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580298369; bh=eg3qZapD09VJqj25AUJW5s1BYxWsWc1QdQQ9ZvAlPmk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=XcCqcER+jVSebJkEBrCV+cT3zpqyOBwnQGk+S4Ttq9sO8QRGWQ6zSL2wqjZtp/nJz91YSR33mfl5jbB+AJLC6Ijuimt33+OVBEPNiXjXQc+3FNV7pOuqbnyn7PWd3S3AmZnsQK4wChyS+D2/hYQFNx8nA1Ozn7CeYoSVBHWhdSfnt2zs/qjfltATjolwdBVbm3WjNQFM+W/hrZhRm/ktDh5ufPqfO5xLGAuWZUUPChI3JGkJAPP7RwtjX61YQ0K0wzrl4W9ls3CBnOoYDfXXtLfdG5pMHtfGNRCSugGjWytEO17byymNYiPV86gwAjdADRVGZbIX3b5aNOosq2t61A==
X-YMail-OSG: kOSRGu8VM1koXUSXyG39gWeI6AfkTPasE037wrtkzMaXP.GJvGPoSXppwuRuhRy
 zX9WUvnijLb19SB.gaSSkK8Haii.pJij0epyiKqZEN470dKyTNLrhQHmEQAf2TgyLGxd6tYoPpN.
 mj2iAezLnx6RCCwsMwhZE7yfWybzG534y.X0POQ9CqZ8Zs1KAWFFbSXAYv_ooRO52hB1cmdydbH4
 SlubyXgG7AgAeE9k3ladIZb_orhvi4LWB.RwW2cBkQhseWh3pmTN2s23hXhi0lhCTCsw4ncaYzHZ
 IvWSl5mUAjNw304VAtsqhjWNT5m_x8RSk_wK7iD1OjqLVQqnOJyjW66SEVNEjLVV3ETWIAgSVkP2
 cqerTj.v0.M84lSEX.oDDupvh0dY7EDdTKuKBbEqxcZbDZRBpMYHo_WHN8dfm6sEs4xiAo3reGlI
 XtK.u7lmOmB7Vgr5_YWNo.pgU.3JY5F4zNO32Ta_T8Z1IgDib1W9kzZIaTFhqleOgvYGbdMhQe2s
 RFtXNXeMkfBBV2Xl0mj0AwZkYehZVaUyzsV.DX.VcezR6o2vfpzQavKTHrNM5QC4fRwRFr5cNbe1
 yHCjlPNX1CSHKO7Cb06DusnSmPfyq_YM5nfQxUIfqBGgO9iCRFDU0n_gSGpj96IyC5qCFEvO8w3a
 y7pwsUY0VoDBxDnmqv94AQySZXUj169egm4ntRDDd2LZDVDF0QJDC2Alx9PnO7lk6GWCazN4kW.Z
 5pgB5LIQhXzISLK4JTQvvilJiHdCTBhn3TGG6Dnzk9mq2bukEHnpGSWb0WT2u2ixFNzQnHy_xtAg
 QTJchD7FRaG60zUdEIUj3puFSPu8wzh3MObDNhiAbTtq0Q.d0L80E6oKFpgUi0yBhmv5uadd6uP_
 jZ3hzHqy.V7pDBaTKD6cn6Qptv9nZXodzAKZaijjhjkBzvkVTRt6SYpmSivrY.NpFaEvnN0SY7l9
 PgQLq53Movh8.UVAVZbuQSL09NjDGEEoNeb_U0jWIxwfPNTgRh_UoZDtN4Jyk2RA25vut3q2ipEL
 jrCox.A5Dt4mPr4W06eO25O4eo4yJot3TFthnBqaGjiB6bQA6P71k_F1_iscWHXOLWgfNEfoG9_w
 8ju0J6v28hBWitI4zngtZEZGcDvJPSjhG1l330h_wvM0WQDTcEgq9lX2OVNAZT7zaJOOFm_pAcpo
 _.3SDXsuezgmW..4jSJpvZN10Sz935PoVGDfbYlCeBkrGXsCtzzcpo3HSSdhmEm3b_eBfUXxmjZK
 FHEQF0zUut7DzihERI.E3J.q2t2nvZhp7YaYastp1B2Z2mhSxvoxx8mHkZkVYUPHyWdi6RJU-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Wed, 29 Jan 2020 11:46:09 +0000
Date:   Wed, 29 Jan 2020 11:46:08 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh111@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <166764213.813061.1580298368358@mail.yahoo.com>
Subject: BUSINESS TRANSFER CO-OPERATION.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <166764213.813061.1580298368358.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15113 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:68.0) Gecko/20100101 Firefox/68.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dear Friend,

I am Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank,

Please i need your assistance for the transferring of this abandon (US$4.5M DOLLARS) to your bank account for both of us benefit.

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me after success.

Below information that is needed from you.

1)Private telephone number...
2)Age...
3)Nationality...
4)Occupation ...
5)Full Name....
Thanks.


Ms Lisa Hugh
