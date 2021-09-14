Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB4440BB05
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 00:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbhINWQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 18:16:10 -0400
Received: from sonic317-39.consmr.mail.ne1.yahoo.com ([66.163.184.50]:42971
        "EHLO sonic317-39.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235254AbhINWQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 18:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1631657690; bh=7t/f/rwmI4aru/OpBUTpzrmLZ1IdImYeQocNXP9+3fU=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=kRvZyaP24RoD3LBfIovZakDwezvRSmL7bsprPerIcqfqP4SDiLi4qIKeP6J1irlKX/2TQJygcwTNoNg8b1f+lNTfjS9JnsOTYaAcTK2+nmlr1nboPy2uOn16hK79TXideu//4+5qHejIqWqclW8rP2+ZZjTG1XkffPyZP1eAqfHL4OBuyvh7ILxsmaHdjJG2SC0e4V4ikWrp6A45tfc4b8WPawAVKuKVjLieOXDENbS686UJ6xlXhM+8Ua5SKGXoAfKUBVaUSOWsUB8Bq3tbZ6rOjVJxHDko25/FyeSuEKKyLvry9rfoVH0dolfj9BSSMh9vzjCPaKxSMiH6Lo4P3Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1631657690; bh=bjjI1zV+B4q66Z30Z0vaQ3VAgTVdaRG5jOxRIEgu10X=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=P72/bNm5fLHA2Z8wTU/ReBhNvZdnGFemZSPH3oLaBVeD9GfAocFLqdNl4BCsFc+qiyEazloDmtsLCyBlLCbY5VVHPd8cXmCv/Jr2//ASu85C1CXMg7lz0WCcas38NwqhCZr8CGmxYO4VwWgQ1ppM40Y7KgtGmCP+UIUlCccP86pvxsdAv8RBmR2cuW1WFTG28qTNity+v+bFZ3WuHfhsJ+k9/xRjktPKAV+mTDuysmFus+qQd/FYEcEhmKT1JxKKEGBKz5hcxYCxy5MPWMgPQg8LBOfgVDpkp/j9U4giSzf+xHrVR7/q+SaQ7XKo9ETfQh5HSTNReYseuXEsUmhStQ==
X-YMail-OSG: dOvq3VIVM1m4PYKtAWTNbkTNTqe9v26OC4NlGV3pRvCz.XlZG7AdJNLRvMyboml
 RUKHmy7t5N1fVx0hK3Y16TUkIwpxs9cYZW7QC.X1yR1HGez9xgCtNsWlwz7EiJ.i_fhvu.F_glLy
 gNYxtPp3OhdWxqL_jkWqLMuOYnGpGSEM8q8QWx7NtmOqjc_WwoT5AgIPJuQDJXkxl9xa8Jr4zGyR
 ovaZUDwZtJg3_QL5yaxxt.FttvE1b18PBXrTNaJ0aDA9PYNeHCDss_hjxaD1ctG.LDRfvwC9OTvJ
 8MUKtXa1LgSJT5P97Mabr0rE15mPjFmaE_VtKXLTp.8J3fBXqCgKfF7Fn7twBO2xIyPcElL3qx93
 2i1G.TLXhhxbF0I80IdLnIqBhalp5mqvf0GxAQEfsiiN0.L7iDxVzsS.jBatKEzq0IsyIrIFna8D
 0dmS27Zt5pURcT.X7ghRUiW_xLIP7rukEHJjwjuTSTLBEnYLtaFZ5CR6k3vJ5mLY_DcLY_ZzValm
 W8e3rKgVN1fwinvRWsd0nOBySyTl9m3mSyRx_KCE4zAI6D0mHEjRBPx5i1S1UHXbvlfTLn8peeYB
 GI64gqZPK1M1aMRagU3Yk1kiV6L4rUfTzJKUcKW9ESnTIifTgfNhquqKdoISEneOq6A9pwUzPlcO
 g1d9wU2JY47adubQu0iKtFlfaXlKQ6xU_QvWOT599OaC4wc.LbWWXg7gKs2bxOsBycN0fq1CdC5A
 No5gZ2pe3zXtbWnFyOjOtv4dRZ.0y5wfH0Kelg9HBja9bahX4HdpYskC8Hwd0ZFcQX2vRY8G6kMi
 GKvFTZK05fHBGgRqzDzodgF0V.F.uZdEHuq.YDFY3tJP.m.m3vLWQEjlxBZTbkM55tvxjmeOrcIF
 PxitFi2gLlM34Q_TdvY6oqiY1qnpZvGUXsES6MSfhKaBTUXX9_llt5nY6sD_Wmztp2y.u5gbKxw8
 1xFyF2YFOwt3se4x3BfiLbJJRVCmuGxMY9.yDPzBsH_ehfAaON3y_u9FErulqv5k2hsyohZEdN4z
 KdEqO8P_3PE12lU9zirQjrBjuRLP4qeXw4pWTg7uNqUg8krf7Wg3cbGtkDkeHFR4CtWh.SSVM3Z3
 jrm1F3jqYyp.Lpmxrgz.mWkX2wHWXw22A5EOjaP_y8uAv7Upmg2SccmBK5zbrO8xKQ0w3Tu9BOTW
 tTGvWLZbKporWWEfga1upwIw4zsAdiy6rH0SSBsp3wwhcUf5rdUGhY1UegPoUPMJvZyGbcY7V0Iw
 hWwr8_.ezieI2MoSTLu_c0Ad6b0DrXIs_2hMzAz.rQtgPruGXu3h8UXvsBIAX2QjBEQ3ODcuJuCz
 F.e7st4c0P6aoauC83Htv3A6P5krjkAbCn9Wdn1UtXwcTD86jigHtIKDMJT3k2mHdnpIEZDNjnVZ
 esRQeWhXdsrvZPK0YOxUFCV9eXwq0RNqH2VlCc.8fQHlgG3zy3Dt5wgy7xeCCEL.PDrNISQVS935
 m0P3k6_19rR.XuXfs3NyYD9KvOlVd5Gd0AurZI7LFjT0bkSVGMO5Ox2XsvhX3kHl_2lUR8CAxwR5
 k4kUgO0YALkPW27vYt__JChJTfzPt1mSpP0ZguDL.Pv8676.1eIYouSzmVV_Q82NTCajF.E2WNV9
 b20zFuNTDquRRsoFB5Yk0kXN0QWVpOH1CWWsqoBA7jHcIShe.L2beJreBvyGpwXAElP6Gt74dNr5
 xoQkJ7Y_U.8jScBq599Ky7KvOfajgm4LvakMTf6eJ7.WKotejRwmjoiOZz37CfoIved1NQmjBy73
 grikLdDcrs9LITCKNYkSrrpn8Uk0IkqNn7qlVpgYR2qoLtVFUOAh_sl64kfPrsTLYB_xPgpRKiKw
 Et3hvBmE_F3D__afyPyaxHL.OpjuX8n2INJ0jTtdQpnydkqhwn3TSYUO4dbp9Np8kwsZtVpbtda9
 aEPzBs_TPHUw1U.cVA81zSrqOGy5ihe1YPqxJEo50opr39c_INOzYPuqAtvdhfHDp1NOMh4QEwdd
 GwBvF0w1rLslE.GHDvO1KQwX_nPkUlDXz_59pY1yPeoGsApx2QkOl0bESt_ZVrsJkfeXuP3RpgcX
 tveHElQeUgLxSvYgCnl_eUHhK0B_6MZuOGE4qdCJM5gpcibB_yTgQ5D26I43XdSZgde4qHzsKUrw
 XhlVTNVGCmRmkp0ITOWd66r42ZDB6UvQ1DjHAWyjf4AbUn5EVBGPG5pchNuXLiBjM2fTME200xKX
 0MFO2BT4AXOz2wlXwzc2UuAo.VB7I4DEo4y5yYfg2omsdhVmCK4TF9utGWbeaN3YuIkZ0JDZF.Q-
 -
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Tue, 14 Sep 2021 22:14:50 +0000
Received: by kubenode520.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 213bc677fa039234cb827bbe34ec773d;
          Tue, 14 Sep 2021 22:14:46 +0000 (UTC)
Subject: Re: Regression in unix stream sockets with the Smack LSM
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jiang Wang <jiang.wang@bytedance.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a507efa7-066b-decf-8605-89cdb0ac1951.ref@schaufler-ca.com>
 <a507efa7-066b-decf-8605-89cdb0ac1951@schaufler-ca.com>
 <CAHC9VhR9SKX_-SAmtcCj+vuUvcdq-SWzKs86BKMjBcC8GhJ1gg@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <a5dc3f59-edc2-825a-31f6-7914c97a14d8@schaufler-ca.com>
Date:   Tue, 14 Sep 2021 15:14:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhR9SKX_-SAmtcCj+vuUvcdq-SWzKs86BKMjBcC8GhJ1gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.19013 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/13/2021 4:47 PM, Paul Moore wrote:
> On Mon, Sep 13, 2021 at 6:53 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> Commit 77462de14a43f4d98dbd8de0f5743a4e02450b1d
>>
>>         af_unix: Add read_sock for stream socket types
>>
>> introduced a regression in UDS socket connections for the Smack LSM.
>> I have not tracked done the details of why the change broke the code,
>> but this is where bisecting the kernel indicates the problem lies, and=

>> I have verified that reverting this change repairs the problem.
>>
>> You can verify the problem with the Smack test suite:
>>
>>         https://github.com/smack-team/smack-testsuite.git
>>
>> The failing test is tests/uds-access.sh.
>>
>> I have not looked to see if there's a similar problem with SELinux.
>> There may be, but if there isn't it doesn't matter, there's still a
>> bug.
> FWIW, the selinux-testsuite tests ran clean today with v5.15-rc1 (it
> looks like this code is only in v5.15) but as Casey said, a regression
> is a regression.
>
> Casey, what actually fails on the Smack system with this commit?

I reran the bisection and got a different answer, but the same set of
suspects. The change:

commit 94531cfcbe79c3598acf96806627b2137ca32eb9

    af_unix: Add unix_stream_proto for sockmap

came up this time. The two suspect patches are related.

The Smack access check on UDS stream sockets is behaving erratically,
as if it's using random data to make its checks. I can run the same
test on the same system with the same kernel and get different results.
The trivial test, where the Smack labels are the same, sometimes fails.
But not always.


