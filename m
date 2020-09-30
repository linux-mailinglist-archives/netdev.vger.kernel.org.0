Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA9227EE01
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgI3P4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:56:24 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:44690
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgI3P4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601481383; bh=RELQ6zEaKUzKotEk3T33ncEVq3IqazKA87XFz5LBnDQ=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=YREuWAA9BgI+sDAXKonin6pM1Z6JePzC6H3DozvvlkI+8QHbUk9L3rRz9ws+XDtHxxv7UNK1rVRsBfNsGGOXW//b2pTVzyoS2lIWVWe4J1CLCT50niU8+Y2iEckvaG0lqXd6soJ6q1YR0hzEgNHuEaix5ICY5te/1bSI6+mvrjO3LV5z3QsmrMAWLVvDBN5b/omKVXI38VRnFDwYCbrwc6iaD2IuBxxnjl3yhvHXlwnBqBhNMCRur5Kbjd7P55VIjr8sqm6wqSOt9xAJHrj0BcR3wN5knxcpyXtgH6upgkfNSA+Rcp+x2fIRUeYlvBfwXfKIKazk3ggYjdJpgd3Yog==
X-YMail-OSG: DlAYhWIVM1nEoZgQ.gTV2uevcLhaWDdPyQW7eTYyCPW.jtc_Xu7KWxL9.P7S5JI
 OIspIMKrRxqo92PuCKA2P4pOLQ3jXgs3axUgZL_rQdDkVJrM2YnUQBOh6aPGVRdxm3ELchi8QYd0
 VzXFpJ221xM.VNOta15KkE98zc1HPI4Z_JOqkHqOHDPbcV22wCNOpnWX8jysDi06jjUkMtsTCivc
 Vnd9CK2en9c9YFUNZgElmz4lAbvQ8582O0bs2RGrglrBIFWfIeMYUvoUVQ37SjzLaAI1kfc2LPrq
 fL_VJYV4xDqWzCVE2R_Y2L5b.7R1OsHL7o9jrUTgwxZXqfkcLf5xDBtKrqBrSaUcXQXtsmA1utLM
 vgiRzU3JQvVJEOCSCy3HcvJSy2tQGhD9NZkuCnK7BpY3IT5oYc8QhmYICDeF3.DrJHaoPYkVQsql
 c69aZPDEU.T9nZkjfd59MzUFgt65aehOplaqyv_o1Zc9wJw3Py6EMt9zXCFtd.MsQ58A5n0vcqAd
 r3gRZ_YmLC4wd7KOTl5JuNKolNyuN6WIg3NdOjKAGALXKxZbu2ABQUmioO5rKjF1WE7HboTRITGd
 _WIDGbAlIjOadwWpdy0YM8qPANZMApoZH8DA9xgFh7NQcEVadDoq15603Q9NK5SolEb_YHPcwA6C
 rh.GAJ4_zbR_Tfs8iYBWs1atyE5xKQ87eDL0kxD6AOj8DAfTpbOgsiTCoXHb2ujrEKJHb8WR58rP
 WxBCyUiSNWB22C3a9dtVozf.OEgLTNH4YL58UbwDvxb5Odcvuh1Kji5L3B1fMhtM.SX.L0WDarZh
 nPoMYPpegkyD97yMs4AomVfmxMGHbP1GvY6d_GHXUUy4auENbEmTs1YymA7J7iyoQWwDGdW6g5V1
 C.xLx_itN09.R.cP6v7OIArQjZzXIyQOsfnM7.x212204byEtvY3gxuyQG1pB4bmQ1JEbiFgPlzQ
 XJ8YAgXDRgJC44c_NlBqxiGfEx5NTpKLOiMIW39LwIV10Ht7TQOUhI6FJ75wVdIAMABtbUXS9EN2
 Edk80ao1jic82hiS7Cb519pAi066.pU.Vqujy7WM0_EHFPrska4gmmUGi9mNo4kqka9kOVsd2ZYg
 iP_MFLE30z7rkNfHYkcyC1Sh_dFeXHnonGjE47kdO.fzXDz6xn1nz2kTh1WUJPN.q7giwTbjePoG
 6BtF6hIf7I.z0XO1RTdZ1MD_b8J6c4AdHFpDMGQz.jYKZmSFgqKO4MSCbqCNlI.n3LJCiFcGjzDO
 tBNQVQriJJ0fFmv9QGtrpNxnm0b15r2DkG6nJaW6a_0Y.zOyUVVCTuYL.vqgMOhlpE0R.Sjge5cl
 Cza3l6Ad_DEUx1yJnWM7jTZ.jKuP01CzfiYOvMTHHYn6aLdZwS.kIP3TuV1JL50vgkJ13oZ3dXTX
 oJq4Q6gULZ18tuTgTioj2igkfsuKOKsRKSCXLWK4hqs5ja9Octq23Iym4t.QglT8HZeJ0oYXGxLf
 ayXIcuHJz3B5KVhPsH5QcU1C3qcSzVSZ30nwi5Ab4P9kVLhwqOKZyI7Mk2AEMGpj.TVmTUL1GXbL
 SlMxMW6Polw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Wed, 30 Sep 2020 15:56:23 +0000
Received: by smtp418.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 8a38d755fdf2675bafdb143cab02cede;
          Wed, 30 Sep 2020 15:56:22 +0000 (UTC)
Subject: Re: [PATCH 0/3] Add LSM/SELinux support for GPRS Tunneling Protocol
 (GTP)
To:     Richard Haines <richard_c_haines@btinternet.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        stephen.smalley.work@gmail.com, paul@paul-moore.com,
        laforge@gnumonks.org, jmorris@namei.org
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
 <20200930101736.GA18687@salvia>
 <0a5e4f19d7bb5c61985dece7614dc33329858f36.camel@btinternet.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <c075cd58-983f-0386-4281-6ff1edb6920c@schaufler-ca.com>
Date:   Wed, 30 Sep 2020 08:56:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <0a5e4f19d7bb5c61985dece7614dc33329858f36.camel@btinternet.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.16718 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/2020 5:20 AM, Richard Haines wrote:
> On Wed, 2020-09-30 at 12:17 +0200, Pablo Neira Ayuso wrote:
> ....
>> Why do you need this?
> I don't actually have a use for this, I only did it out of idle
> curiosity. If it is useful to the community then okay. Given the
> attemped move to Open 5G I thought adding MAC support might be useful
> somewhere along the line.

I am not a fan of adding code that "might be useful someday".
There's no way to determine if it's been done correctly and
may interfere with a "real" implementation later.

