Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5A06B8E03
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjCNJBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjCNJBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:01:09 -0400
Received: from mail.amblevebiz.com (mail.amblevebiz.com [80.211.239.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF599474A
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:01:02 -0700 (PDT)
Received: by mail.amblevebiz.com (Postfix, from userid 1002)
        id 72C7882957; Tue, 14 Mar 2023 10:00:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=amblevebiz.com;
        s=mail; t=1678784460;
        bh=mG5KF9rXIT2hCcIXZaMY449X9Ndwb1czFhgZLlqDg7A=;
        h=Date:From:To:Subject:From;
        b=mkmX/N7eUtUbEA8oSceJPNNQBLA27Q5Kzg6iTvT5Pgs9oSse0XSXswACHp+EGaTYb
         deXZsUwVoCG8S35rZhPPAq78rC2sEmzy2QikyKUTw0/ExD9xyM2U3BpSiEMIvvsuQ0
         hEX3e7mmdvSakU7gwdheZlnVZzy1l9C4GsMn68nbhMtOCZ6QIbBs8o5+g1wPtK6Fgi
         IUP3q4S3gbeFmhLycL4aA1SsxicmxWlQuN8q/hgq85nAH4OMDieYSq0GJZ6433IV+a
         8erkn21fYjoT2PtJFzjcCkV4c2uioLgmqzOYtTA1dAZl8hs9JZjV0nkWvCMN2z9Xjj
         OR/y94wpPLe2g==
Received: by mail.amblevebiz.com for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:00:43 GMT
Message-ID: <20230314084505-0.1.o.1f6j.0.x1i5gaj3m1@amblevebiz.com>
Date:   Tue, 14 Mar 2023 09:00:43 GMT
From:   =?UTF-8?Q? "Luk=C3=A1=C5=A1_Horv=C3=A1th" ?= 
        <lukas.horvath@amblevebiz.com>
To:     <netdev@vger.kernel.org>
Subject: =?UTF-8?Q?Technick=C3=BD_audit_podlah?=
X-Mailer: mail.amblevebiz.com
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,URIBL_DBL_SPAM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dobr=C3=A9 r=C3=A1no,

uva=C5=BEujete o bezesp=C3=A1rov=C3=A9 podlaze pro v=C3=BDrobn=C3=AD prov=
oz?

Jako sv=C4=9Btov=C3=BD l=C3=ADdr ve v=C3=BDrob=C4=9B a pokl=C3=A1dce podl=
ah =C5=99e=C5=A1=C3=ADme probl=C3=A9my vypl=C3=BDvaj=C3=ADc=C3=AD z vlivu=
 chemick=C3=BDch slou=C4=8Denin, ot=C4=9Bru, n=C3=A1raz=C5=AF, vlhkosti n=
ebo n=C3=A1hl=C3=BDch zm=C4=9Bn teplot - na=C5=A1e podlahov=C3=A9 syst=C3=
=A9my jsou p=C5=99izp=C5=AFsobeny nejt=C4=9B=C5=BE=C5=A1=C3=ADm podm=C3=AD=
nk=C3=A1m prost=C5=99ed=C3=AD.

Garantujeme v=C3=A1m =C5=99e=C5=A1en=C3=AD, kter=C3=A1 jsou =C5=A1etrn=C3=
=A1 k =C5=BEivotn=C3=ADmu prost=C5=99ed=C3=AD, odoln=C3=A1 a snadno se =C4=
=8Dist=C3=AD, hygienick=C3=A1, protiskluzov=C3=A1 a bezpe=C4=8Dn=C3=A1 pr=
o zam=C4=9Bstnance.

Poskytujeme kr=C3=A1tkou dobu instalace a nep=C5=99etr=C5=BEit=C3=BD prov=
oz i o v=C3=ADkendech a sv=C3=A1tc=C3=ADch, =C4=8D=C3=ADm=C5=BE eliminuje=
me riziko prostoj=C5=AF.

Mohu V=C3=A1m zdarma nab=C3=ADdnout technick=C3=BD audit podlah s komplex=
n=C3=ADm rozborem podkladu.

M=C5=AF=C5=BEeme pro v=C3=A1s mluvit o =C5=99e=C5=A1en=C3=ADch?


Luk=C3=A1=C5=A1 Horv=C3=A1th
