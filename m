Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F87B12A28B
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfLXOmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:42:11 -0500
Received: from sonic317-32.consmr.mail.ne1.yahoo.com ([66.163.184.43]:41074
        "EHLO sonic317-32.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726128AbfLXOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 09:42:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1577198529; bh=17dVP7Uubr9+jNqE4DjEgXnP0HamWyMUmKfcpo3/pYc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=N+mmsTrmbwDoqx+1sD2j/sf7xF/v6QcWBjaOEoSxKymawGT9WeupQZRI2fk+v5dqPMmlj9zOrztyzX0UW6owY2pIZ7lj51S6t7idHrQX/frZ8MWekDWcKNhra78eLFoo6h6sk8fWeZbs9u9rPD5QkxV/jlH+0wEvRarprN2qJ/zBpYkLaVHHa5oX+eeosqflDXB1UWdwC0/7Ah/ol0wiS77K9Vt8cGhhu/Rs4X4THmvlyS1GSOiiRmw35wPBC7sTFPKkWstI65rQYFpyPZ7VVCW5pFYU9m5ZxM2DZAzxCHNL8g/ecDwwddlVALd7fIqQxaISSDPB9zw6cXV6SXd18g==
X-YMail-OSG: ZabDINAVM1lNeUrfmpQn_HZshuF93v31rZh5DlZEpSRw.sYqphJ944wTriWr2G7
 ybCsmv4u_jxXvJBtmVPh60PYD19aMrH.u4y_e1Zj9Bykqp6x5W6QlQ2FFNRba2ZUcXZcDmI.VQ8A
 cREUxWreUcvqgYR3a827dlacrIWTo_2XCHvMkx4EMrQ1b0FBR5LF84lo_IMhwe7B3dMDFn5i9cxW
 0onhCY_5wQ45aD0sSMH1INtI17.m1ehXEvHYygZTG2xaWBCR8_mHzqTRV2gHV0FEellRS55s_obg
 aW18a_AHCjidmLuzKBg4K5QdJMIcG0ee3vlsOK0QOrovLHyADThX.Fpns8MNYLxIVTskXmVwFWrm
 d0eQCgHoS2u8otVfKApcEaqLdZjfsWmtlXReSJJ.VyeygrNAMtT3UZtMiH2Y.89DJ7c2lxkCwuWC
 8qtR86iz6V8S78ShfaBmTdPtYaGlpmJ25N8HdejtXdF4ovLeUjiM6sc_zCbibMbIB4OZu779_r1C
 yVe7fXzw0xEibi8y3auxeJGRqLFpPreBxjTWUC5JzzzWLxycKS5Zr8K9cJQaSo54s8yvBK_LzwjA
 ZzuM.K.TDOUwciFPTV.UgOhy74KBgPW_ex0_mQqJpckSuBOmxLhJyGr8N5U8miIdbvH9_BYQrUWz
 SLl3N_V8ucnQ4XOuH8cYZOyUJopkCewO5vQpFBqPtxzJkkIXY9S_1IQSbdgijY1gAhVduBz50aib
 wKJyFAFodHVX7qucc10ovueuMlK5NXVEhOE6rQRWQffmyU9uUsV1zKFZmI72H7Hu43MhYdxC4Y55
 5YG1meG8sLpQ0yO56NfQ8ubDmrhaKm3aQGZLXl6fRgCEMe5SnT29sVmmAC7y8.I_B6t8uiD.v9fN
 6X.F37qmttJOhl_cBjbDELYXQkUC7tQm9P_eG_ysXNao2zkyvrIrsl3rmfNbo5DuSsma1rEhvmiP
 qOZ3r_kZ_qpDvsuONkOaH._gWxAcfnkcG6fqWVafRMQKBvrfLNHkUUPA5qEGDz.GkSQUEHP76W4i
 z8NHyTr.9V_Iqyb5FeWXOBskBtNgx0Y.D8_PUqyJpVkN_v1jlXAqOWFgEXIols7xEqN_wMwCdFTk
 5FBzP.owN_Wb97LTdbcENrO.6M8Hj3gUFVx6UTrPo3HlfFUiZfVhDNNEv5tfzHxtXkWtCliapGsA
 LC3yqgwG3rq1tF5hiCV6cDIJdrg_t0toR453VoXIpmzBRrF0hkJ2uzK4QVE6dxve_eMu.2zzmN6s
 AKWdGfuuK7sg2OYNl8teF2Jheypf2Py4U4kIC8aNfP4AKUuA3JvAiHXwEXiQaFwOFdyFXrnItHhf
 i
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Tue, 24 Dec 2019 14:42:09 +0000
Date:   Tue, 24 Dec 2019 14:42:06 +0000 (UTC)
From:   Pamela Render <sgt.prrender@gmail.com>
Reply-To: sgt.prender@gmail.com
Message-ID: <708447843.3266486.1577198526464@mail.yahoo.com>
Subject: Hi
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <708447843.3266486.1577198526464.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi dear friend, Good day to you, I'm Pamela Render, from united states, please do you speak english. With Love.

Thanks and regards.
Pamela Render

__________________________________
Sent From United Nations Wireless Device Server==================
