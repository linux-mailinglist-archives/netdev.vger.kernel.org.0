Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5370E27B222
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 18:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgI1Qoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 12:44:37 -0400
Received: from sonic301-32.consmr.mail.ne1.yahoo.com ([66.163.184.201]:46626
        "EHLO sonic301-32.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726465AbgI1Qoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 12:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601311475; bh=8orKaYfnLOuvEXtLL/BuUKhkuI5qDLCKTV67QIOFeG8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=eSrH/WvDyuZhUdsONRQvSEf+QZKdMvQmCNzANn5PQ6m2OHUDUAK27c7mphE2UqjKxyFBFfHRjn4FyLRAXsGCUNswWyRa8Ou7WIIvLBSGba4a0UUxaTeZRrOqhOppE8GhuyODqQSa8szJzjyigEEwqWIpxApMjIsHW+SKHfoWXJxdxGFFIBo+iRRKZgka3r7xZS8iGiDr+BZsIN8TENYaPPQixK+MPIUeX+YwtoP1535xQEZa5p6PsJI2a2SqDYZxllANAFmfMD//fbBHPL1faayS9uXvva7VbMBMdMUo4AO1+81VwKjEP7vYENg7jk7Rh8LzT+HNd5WZew27PBR0dA==
X-YMail-OSG: uelQv5kVM1lr2v2eeVDbCjfA0K5IO1aaGI6GjOclo2evQ9PoW_VGJdcWzCV4azf
 pcbjkptV6cG0epsFetAV3D5qTssE5oN7Zawknytj0Ubeu2CBUhBOjSV8cJ27._yndRyllX.230V5
 ZIvoH8yZ.QjlKE0bjtHm5sefuTpY.NTIwHX9AAn8jYXGrlOK8LjJP3qZo39zpb6ChUoSYZrx0E_B
 z_i20kOSz39VQcJ7wya__7tyu4.MXeERerU7Ql.mzYKYFvjoXXT7Q6GlW40hMw_CF0V1MWhkQeUq
 bt5MbNohjJ7xANBWd_tuS6YQcaupseuBN__9lEFcIiY08tN9DPdXCFnbTxykBe.8VDuqihjhDr1H
 t1L3bHw0HQl4yjVmk6_qQk8zV5LjBg4mWQFbGCkHMcCiC843lxtlYsTdJko.MmZrOjT_LONPEJGc
 u0_OxBT_4AMh3VxTBRnqi8UWIAlGIvlYf.XLsBnB5tmQyPBSNf.Ww9dB3fPOW6a3Wu_pMdNZhJGA
 R__2xCgtt2RwpIaPe6q0Csm4LiMvsDSVdsY.zwmjfXTNeWmGYbZ3JY6lPOhCN_3rs_ES42JoWFIZ
 PHcVhfwZ4.ykiwzjmwwAlq4tjBYL8inbyLDdtn4CM8cJHanUro.Qe_byF1DG5e_Bh7xvNajKlosl
 DcXZrESEqnuPS0VByQiR2novQOTZizWFViWHPMbojVgN7RDYiZC5C0rZqQWaeU16a1bbjbwJQdZm
 3BtcKv0lU4S7P83uU4Ur4a6fLap2OuJ4JShEUb9ZmOy7PbWQRTI19iGg1Evy0wHnfuG8x4xAPmii
 w1q2uxlqJKC8XOE19p1.Qgr0c4KjLIAGNYAOoMdNOwnDstqGgYUFgfCJFkIsLS2l3Ou5Rtvepokf
 33QOm.awv_HdX2KlMSj1iegPqo3BlKpMxhk_fGnQkx.Yy8f73T4H7D3xeaiYrMEoRJgXscORa7yo
 4tj8SeYrQ_n4MnLCbdtbVNfnshD9nnX52iFppMTxtHGYMf4CCqhRLwcOkj1CXuGmAap8CaEluavD
 QLYK0L0Nv5wrH.Umv5avir44TMSoQw_D7oITsZCG9aD8Y4ztX62oWAvyWd0LQFMIjqj6lDL3jvkr
 fbFDw7bKT78EG_F61H1PWjZYn5XokcI2mVEJSV3HtvHHGhQzNWN8jYt23KhWhoPzXCHWIN5ZzXyj
 h75lbS1E2VTJkB602vsMon_rKORPLfLvGv7eobhuolHeVVMFWQSTCDtGAn3rqIQ.Mq6fEqzH6BMj
 z3E7Wcs5bmyFtDJOukgDFd1q20lsTlovamCiMwa_jeZEFVzijXzF6sAmK0bov7w6FP.ZVvPax4jz
 6R99asDSpFaFGakERFF159ml5_MENp4_xImPOUsH0LLpTN1Xxpk8Uv.9WR3upj7apVPkqnuFviKk
 c9Z4zaiv.nqk9sfybJEEfnPpXojAGXiy5yq2IbawF7KZSpw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Mon, 28 Sep 2020 16:44:35 +0000
Date:   Mon, 28 Sep 2020 16:44:34 +0000 (UTC)
From:   "Dr. Aisha gaddafi" <gaddafi283@gmail.com>
Reply-To: draishagaddafi92@gmail.com
Message-ID: <1704204604.1656148.1601311474275@mail.yahoo.com>
Subject: Hello dear I am Dr. Aisha Gaddafi.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1704204604.1656148.1601311474275.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hello dear I am Dr. Aisha Gaddafi.

I am Dr. Aisha Gaddafi, the daughter of late Libyan president, am contacting you because I need a Partner or an investor that will help me in investing the sum of $27.5 Million USD in his or her country. the funds is deposited here in Burkina Faso where I am living for the moment with my children as my husband is late.

I would like to hear your kind interest towards the investment of the total sum mentioned Above, as my partner and beneficiary of the funds I want to inform you that you will receive 30% share of the total sum after the transfer of the said funds $27.5 Million USD is completed into your bank account, while the balance as my own share will be used for the investment in your country.

Please after reading this mail try and make sure you reply and contact me with this my private email address: {draishagaddafi92@gmail.com} so that I will see your mail and reply you without delaying, please note once again that it is necessary that you reply me through this my private email address: {draishagaddafi92@gmail.com} if you really want me to see your respond and interest concerning the transaction.

Thanks with my best regards
Dr. Aisha Gaddafi.
