Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEAF63E309
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiK3WCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiK3WCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:02:16 -0500
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F4F7E415
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:02:14 -0800 (PST)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 40669240108
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 23:02:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1669845733; bh=8HvKD2CVEGElEJE0JYydznFvphMHMkRvJKSRiTg1dHQ=;
        h=Date:To:Cc:From:Subject:From;
        b=Bx3VKHglLkRo4AICVrXXokpP4eSh2Ioaj19emQDAhGuyHgGc4wOgxawktVZBXtfSV
         vLTDxu+rV93qKxqQGCbIOyDkd4rgt9fKBQ1hkAuvZB3euk3DvLyIZmPdJzlpjCy5s1
         AenAG2+6n4F0G3wBDJyIYxdPhce2JzxSzlHqKoK7QMCi9ZmGpBXijHDHpHqz8YBfv9
         CIAesfLYxFWsqAJcNS2lWbQr/lNwoZDN8qWaVaP2C6oDblKVJg6miOKc2hgZ2p8Uzb
         E1q5VmmzOgAY1Dp0ldQXDbE58WqKvxwLy2oMgNFAXEO2HSfMPc82N9gtsuOuy7wf2e
         NYNSw9dGy6LVw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4NMtTt5yFzz6tmq;
        Wed, 30 Nov 2022 23:02:10 +0100 (CET)
Content-Type: multipart/mixed; boundary="------------MYqxwZwKJN1Fj6NM1FFTbhJx"
Message-ID: <8b50f492-2a3c-5f37-76d6-61f7fc692218@posteo.de>
Date:   Wed, 30 Nov 2022 22:02:10 +0000
MIME-Version: 1.0
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     BenBE@geshi.org, github@crpykng.de
From:   maxdev@posteo.de
Subject: [PATCH] Consistent use of local `nlmsg_chain` variable
 `ipaddr_list_flush_or_save`
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------MYqxwZwKJN1Fj6NM1FFTbhJx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

During a brief code review we noticed a minor consistency issue 
regarding the variable naming. This patch changes the use of ainfo to be 
consistent with linfo.

The people mentioned in the commit message helped in the overall code 
review.

Kind regards,
Max
--------------MYqxwZwKJN1Fj6NM1FFTbhJx
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-Consistent-use-of-local-nlmsg_chain-variable-ipaddr_.patch"
Content-Disposition: attachment;
 filename*0="0001-Consistent-use-of-local-nlmsg_chain-variable-ipaddr_.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA1NTM5NzQzNDVmNDA3NjVmZjZjOTY1NDNiNmRlNmVjM2Q4YjZmODcxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXggS3VuemVsbWFubiA8bWF4ZGV2QHBvc3Rlby5k
ZT4KRGF0ZTogV2VkLCAyMyBNYXIgMjAyMiAyMDoyNjoyOSArMDEwMApTdWJqZWN0OiBbUEFU
Q0hdIENvbnNpc3RlbnQgdXNlIG9mIGxvY2FsIGBubG1zZ19jaGFpbmAgdmFyaWFibGUKIGBp
cGFkZHJfbGlzdF9mbHVzaF9vcl9zYXZlYAoKUmV2aWV3ZWQtYnk6IEJlbm55IEJhdW1hbm4g
PEJlbkJFQGdlc2hpLm9yZz4KUmV2aWV3ZWQtYnk6IFJvYmVydCBHZWlzbGluZ2VyIDxnaXRo
dWJAY3JweWtuZy5kZT4KLS0tCiBpcC9pcGFkZHJlc3MuYyB8IDEwICsrKysrLS0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvaXAvaXBhZGRyZXNzLmMgYi9pcC9pcGFkZHJlc3MuYwppbmRleCA1ZTgzMzQ4Mi4u
NTYzMGQ1MmMgMTAwNjQ0Ci0tLSBhL2lwL2lwYWRkcmVzcy5jCisrKyBiL2lwL2lwYWRkcmVz
cy5jCkBAIC0yMTA3LDcgKzIxMDcsNyBAQCBzdGF0aWMgaW50IGlwX2FkZHJfbGlzdChzdHJ1
Y3Qgbmxtc2dfY2hhaW4gKmFpbmZvKQogc3RhdGljIGludCBpcGFkZHJfbGlzdF9mbHVzaF9v
cl9zYXZlKGludCBhcmdjLCBjaGFyICoqYXJndiwgaW50IGFjdGlvbikKIHsKIAlzdHJ1Y3Qg
bmxtc2dfY2hhaW4gbGluZm8gPSB7IE5VTEwsIE5VTEx9OwotCXN0cnVjdCBubG1zZ19jaGFp
biBfYWluZm8gPSB7IE5VTEwsIE5VTEx9LCAqYWluZm8gPSAmX2FpbmZvOworCXN0cnVjdCBu
bG1zZ19jaGFpbiBhaW5mbyA9IHsgTlVMTCwgTlVMTH07CiAJc3RydWN0IG5sbXNnX2xpc3Qg
Kmw7CiAJY2hhciAqZmlsdGVyX2RldiA9IE5VTEw7CiAJaW50IG5vX2xpbmsgPSAwOwpAQCAt
MjI2MywxMCArMjI2MywxMCBAQCBzdGF0aWMgaW50IGlwYWRkcl9saXN0X2ZsdXNoX29yX3Nh
dmUoaW50IGFyZ2MsIGNoYXIgKiphcmd2LCBpbnQgYWN0aW9uKQogCQlpZiAoZmlsdGVyLm9u
ZWxpbmUpCiAJCQlub19saW5rID0gMTsKIAotCQlpZiAoaXBfYWRkcl9saXN0KGFpbmZvKSAh
PSAwKQorCQlpZiAoaXBfYWRkcl9saXN0KCZhaW5mbykgIT0gMCkKIAkJCWdvdG8gb3V0Owog
Ci0JCWlwYWRkcl9maWx0ZXIoJmxpbmZvLCBhaW5mbyk7CisJCWlwYWRkcl9maWx0ZXIoJmxp
bmZvLCAmYWluZm8pOwogCX0KIAogCWZvciAobCA9IGxpbmZvLmhlYWQ7IGw7IGwgPSBsLT5u
ZXh0KSB7CkBAIC0yMjc4LDcgKzIyNzgsNyBAQCBzdGF0aWMgaW50IGlwYWRkcl9saXN0X2Zs
dXNoX29yX3NhdmUoaW50IGFyZ2MsIGNoYXIgKiphcmd2LCBpbnQgYWN0aW9uKQogCQlpZiAo
YnJpZWYgfHwgIW5vX2xpbmspCiAJCQlyZXMgPSBwcmludF9saW5raW5mbyhuLCBzdGRvdXQp
OwogCQlpZiAocmVzID49IDAgJiYgZmlsdGVyLmZhbWlseSAhPSBBRl9QQUNLRVQpCi0JCQlw
cmludF9zZWxlY3RlZF9hZGRyaW5mbyhpZmksIGFpbmZvLT5oZWFkLCBzdGRvdXQpOworCQkJ
cHJpbnRfc2VsZWN0ZWRfYWRkcmluZm8oaWZpLCBhaW5mby5oZWFkLCBzdGRvdXQpOwogCQlp
ZiAocmVzID4gMCAmJiAhZG9fbGluayAmJiBzaG93X3N0YXRzKQogCQkJcHJpbnRfbGlua19z
dGF0cyhzdGRvdXQsIG4pOwogCQljbG9zZV9qc29uX29iamVjdCgpOwpAQCAtMjI4Niw3ICsy
Mjg2LDcgQEAgc3RhdGljIGludCBpcGFkZHJfbGlzdF9mbHVzaF9vcl9zYXZlKGludCBhcmdj
LCBjaGFyICoqYXJndiwgaW50IGFjdGlvbikKIAlmZmx1c2goc3Rkb3V0KTsKIAogb3V0Ogot
CWZyZWVfbmxtc2dfY2hhaW4oYWluZm8pOworCWZyZWVfbmxtc2dfY2hhaW4oJmFpbmZvKTsK
IAlmcmVlX25sbXNnX2NoYWluKCZsaW5mbyk7CiAJZGVsZXRlX2pzb25fb2JqKCk7CiAJcmV0
dXJuIDA7Ci0tIAoyLjM4LjEKCg==

--------------MYqxwZwKJN1Fj6NM1FFTbhJx--
