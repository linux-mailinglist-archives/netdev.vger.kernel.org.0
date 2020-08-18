Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA162483EF
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHRLfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:35:31 -0400
Received: from sonic303-2.consmr.mail.bf2.yahoo.com ([74.6.131.41]:37000 "EHLO
        sonic303-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726636AbgHRLfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 07:35:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597750513; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=VVVD+gP+uACNYOigGKpZEtr5IL0CuXqpZtO1rypG5wU4niN2sSexsLumNLYx6lfqfBp1OT1rzg1Wb713ee/iEKgPsoOrTHA+nz4IhTV1AA6LxG+AFZjsftSZeLfqSxLH+vbHkrrWHWlj+WAj+Yob6rw07xpqUxU4qEAJ/wq7OctMDPP09qdtcmYNsdDguIIei9l4xOZg0KvL/MPHfOg6auEXaB0P6HQFPCJMocOkVMGBtuqOo0OJbDDztfohH+iuNDH/FaDYX/7ZjIUDze55U6RwRqfpEWIDZthMPJGKgeJ+O5nuTdAL7yGTVxDeHVfbGylkG6+4PxCqN+rl2r+CKg==
X-YMail-OSG: __GOyEEVM1mfD8mVFJalafz8z1FaSMImtONjwWDv5o7Jm11Byu_mAAuWBzw.Uan
 cTnWAoBEHnLuSXJMDy0HmVYv_Pz4cYuux6xTZhvQ4V42fYEfMz6Uja2sNRQwoEj8n2KW8AG_lUhR
 bCNobZJrvCbCP7Xgn0AWlThzhdtAcxN_6lNtLFMTlW41uvhoDPI6_W0M3uzoAFgr3JSkDF9Vp6U.
 ndhtz4oIq7rUrqpJE9ZeUYLJ4KYe_X3xrmQUYmrdh6q66QvKCweBTzWkc5gYMH1Y0syNtxX5jeR9
 a6Pf7jrjgaCqyelArDvt7N9_QTff_qPBEqr4NX38GCsXS7RSQS4CPnKUHrXKuN2arT6sXFaEFlEz
 pKHKCFkvAlTt3_pluXrBrEpiAtc9.a48votbxE9Er0z2OUmb_OUFdjeMGGK539yzX8ndzf7OJ8va
 MgZ02KAK0MX718wu37cypFmF9Yax8y4NUbW1uNnm1ekcXWa_S.4jxMTb3.gDZgP4UfYbgNoephYn
 rofrYHPsWWi9Mxm6ypwVMESP8i6COJhAt5ZL0u99X4Y62WfWvvL3lnpRsVNb_DRZmE4HzbdOKcjZ
 VQFUPHHtxXcemIU.Dbbn4IH7cHawCqbz0pPnEKcimjDlvxnij_jLUCEd8cuazqrQ7UR7bAdeHhqi
 Cjp1VHE_3p4faLJ5OAAHKAyOPoZbSVOkDCIE95mk.TK9ivKo4bee_oTzcN68PDNLDQTOTeYEEaRi
 LTFXJvANPdXfkL3v0Xqm6ckbCiUXZitHEuts5ylDWobP5teZmxrx8qcx2aSOwJgX9YWV5VXRL6bz
 IqmfrlPSc71oaKAAwRpFtVVWirAMQNXAXf2K5MnySXXDqXCtu63qEs6KdLXwAyOuVIOBDUQuHsmC
 xGrqqHv1FJfvBS9V3I.q08db2pInF86H9ZIW5GPfqJIdIOvpyLdGJ5anUvXiK_BDA_6WDByq2l1p
 OCdlpyiJRNyh7ZspR8Zk72LN1raXiuiwo3oacK0jZAyPDHGnPrkcXhG0frSQ8urgwPB9_3gdsFOs
 Xjrvu0oTmTJXwqFepQYDpWSp3A6YIFk3rBcTYBPc7qJFyZ12gIwcrYT4mRptnVNk8lPR3AgZ5.jh
 1LzC9kn4CJVsREGMKjxaLDmm7pWSZBZRi_4O_LfknqlXEfJzjba43gXSjyRoC_CALCiqm7d6yyXz
 oW3iKlAi3udFZnp3r7AJozmgobmQfmF6zCv5rOhph.YzZLkH1jB00LBBSvm27PiUO3r95gO6oDc.
 B_npbK7j6QL3LsOuVl77j6RDIbywiJgU5opVBuPrrvj4tfiI_pBt4zpkU5Dz9X69Pz08MNtGx3vp
 H5Ld.1op96g_wVcySffC7SsBWCfTupI2i6dWz5QpG_3Y763vQ
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Tue, 18 Aug 2020 11:35:13 +0000
Date:   Tue, 18 Aug 2020 11:35:09 +0000 (UTC)
From:   Ms lisa Hugh <lisahugh531@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <713960816.2728316.1597750509084@mail.yahoo.com>
Subject: BUSINESS FROM (Ms Lisa hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <713960816.2728316.1597750509084.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dear Friend,

I am Ms Lisa hugh, work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me for success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa hugh.
