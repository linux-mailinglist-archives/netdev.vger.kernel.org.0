Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D396427D541
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgI2R50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:57:26 -0400
Received: from sonic316-11.consmr.mail.bf2.yahoo.com ([74.6.130.121]:37094
        "EHLO sonic316-11.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727360AbgI2R5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 13:57:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601402244; bh=+5KgqKjCJG6yX494RS6bnUxSfHkVk5sWUVLr6Upex48=; h=Date:From:Reply-To:Subject:References:From:Subject; b=O3n/6xbGFEO+sROunwJTSyYDJuw2FkPcz5HHtvZXSHsZ1UUGS75zAS39uvLtvi/4N2ylWumUNmPwRZaMwLobb1LFPwzJ2STf3qXKhv8HjQ/YLG5i5qKnyeYmoySQgiRNW1S9W14On54Y1cMmmPr0hB9PN5xUu74EzUgSnKPx8V+YN+F3WB/lk0yiO3ZxCpfgUUtdpM+Av8KyxRwP38ssAXp0rzLuNg/Kn7Fr1thbV1eXL9ahpiGUOJ09nmPR7G2tkpkg/2Bhgj6zOZLWFTYSYJ4lKTgf4tc315OV+t+1fLqcH1APN2kfDnHc6J/DC7ksKvZcs50EhoQimcSX6rjBJg==
X-YMail-OSG: 46IaCkEVM1nMt_aYr49sLvfXfA0Xhrq1Xut4QxPzjmYSpUxpiWoXWMQpEQ58ewV
 qbmXnBCThyKyIt10N.OnznyUTv_X60K81p8C8cKOF0IyKBse76X.rCqsC9U7Jl7yehJNqnZ4JD7T
 c5smb8BDNHyV0srOu6MLY1O3bnyEMVUu5T4EPDtNpkItnsWBdgbYhXw7iGZyGryVz9VQz6ve3EW0
 MmCpF8PUnBekpRS0mLk5HO6NwduafLiwRaytFz758PNOVCLyflMF.wPDyArw6mlpqcLHv9ee.5Wv
 dNS8xQvhOR3._4E6qCGfuYzZyHbCmJh8pYZY8WY6zXD3E7SQ8APPciEMj.2.yiwICb2s8pRIV1.N
 FfKwrl.pgyrIF9bTQgZ0AujLQQzPFyhpx89CJbdVdipJ.9nl8YRXVhdiq72CQ4pUbBAC88cRqvqa
 O7XKxbzFlOLzCZRbfrJCgf.zSJf9XkNrQeohurlrGv00ooPyHpqEGg8AA2tl6K.gugdGmqFdoLkJ
 2BqkNoj6yDio0QM.h1y5cIESCgMcylrOxCbmfeG3MSFlD84riqdgqwFiOLCDAKfpkwDcJ9yqmml_
 vK23VkWRbP.DuOBYcP8uC5c7ChAFiXPNtvW74h09ht46miMYeAjrDnhijCEWTJKPFIYAJYCfSK_e
 ewoAqsk4F7EoqNHH.61wfyv4ss3yFQSf02ROmSSXX121q4YTb9_mRWez2tAYbiEyPn2LGi_QoUdo
 sLyojZ_fXMDLvlP5Pwx0ALTj9tLBLvWHxoqecVJEiwUAZxMAjMOdsmzAKpI6RC3nUP2qIcW7eoJS
 9SXLqJ6zfpQ6v0F24T37Dss016Jy3Ru8TBX6XyG9yhHxT4tc3K5hGM0MkfwxF_JENBPtDp430Hx1
 TzMDvfeVMmjGNDZQUiZfBT4rwpEQU7YJIQWBd1qQPGdhaOpjakWDtT9ZMgnizxwBfN4dRxjr3HI1
 eK7xx6izF8Uy0F4JzoOq2D6mRCVht4sYecxLgXXWWHUP5jkvxIL_y9ML0rUcHh6pnj_zD.KnThc8
 EsVXnHhAsXTGXgN0LqTbt.t30OvlJotRY6RbjlGgidatv0kKJJNMedReSmYRjadPoMUI724nCoTq
 u4aoF9ng4ORNYLvZUbOP9olbyH3VdxVlchdaULt_UOJOb7xcqFLMz08d0DHYOTeU0TI2_2b61RPo
 sIgrDB4J75pHdb1ALrQL_ASsnjqYn7GPCiK3u17FoOYCAuTXBlMcZxLM.g.OpzfL9XOg_LKetwqH
 laLWJfAsTlG4QbTHL_IOG8ldBqSFe0.QQ90RzUA4WTXiJu1293B7taAVjrGsCDUqryLYto1BGBKk
 SoVBm3NFy7aQHm4NxMcF25eNOgIfmtKsrjBoVk.uWvdFMAPel.cLZUg4KuuIbwuEsj5TApVkP4_s
 F8wjqQEhVgHrJHYjagZUuLobyuoWi8lsogT29S5.OrbJ8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Tue, 29 Sep 2020 17:57:24 +0000
Date:   Tue, 29 Sep 2020 17:57:21 +0000 (UTC)
From:   "Mr. Mohammed Emdad " <mohammedemdad587@gmail.com>
Reply-To: mohammedemdadmohammedemdad77@gmail.com
Message-ID: <700849087.1996540.1601402241093@mail.yahoo.com>
Subject: URGENT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <700849087.1996540.1601402241093.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,


My name is Mr.Mohammed Emdad, I am working with one of the prime bank in Bu=
rkina Faso. Here in this bank there is existed dormant account for many yea=
rs, which belong to one of our late foreign customer. The amount in this ac=
count stands at $13,500,000.00 (Thirteen Million FiveHundred Thousand USA D=
ollars).

I need a foreign account where the bank will transfer this fund. I know you=
 would be surprised to read this message, especially from someone relativel=
y unknown to you But do not worry yourself so much.This is a genuine, risk =
free and legal business transaction. I am aware of the unsafe nature of the=
 internet, and was compelled to use this medium due to the nature of this p=
roject.

There is no risk involved; the transaction will be executed under a legitim=
ate arrangement that will protect you from any breach of  law.  It is bette=
r that we claim the money, than allowing the bank directors to take it, the=
y are rich already. I am not a greedy person, Let me know  your mind on thi=
s and please do treat this information highly confidential. I will review  =
further  information=E2=80=99s / details to you as soon as i receive your p=
ositive reply.

If you are really sure of your integrity, trust worthy and confidentiality,=
  kindly get back to me urgently.

Note you might receive this message in your inbox or spam or junk folder, d=
epends on your web host or server network.

Best regards,

 I wait  for your positive response.

Mr. Mohammed Emdad
