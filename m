Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDEA4FADB2
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 13:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbiDJL5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 07:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238628AbiDJL5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 07:57:31 -0400
Received: from guaco.floridaarsonseminar.com (guaco.floridaarsonseminar.com [85.202.169.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D31D37A8E
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 04:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=dkim; d=floridaarsonseminar.com;
 h=Reply-To:From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding; i=rae.leo@floridaarsonseminar.com;
 bh=MnUf62F7Cn+TYukvIUFpyVBy5Yk=;
 b=hlWk4v7nW/+E4STnRasY10lkMDLXjTMioUh8qNVeRJmBz/n5zHJt/frCEDSe5eNIfhTz+FZVfgVS
   wUE7zfyvvdAMYZcnrVn8UYx2ZKy80gIKB8HFVXinV4KAl0/0pyZQNMSIEtfcqWRkEWTp6VsdzBol
   tS8YRJCt6TV4pQZxvBRO4cpaVzalyGT57dojMin2HsSvHzoeP3Vt/NYImcCUT7KwbMC3PANcmgLB
   wE6Sm0KQrh58pWe09hSWSdSuLhAtT+yAuMpU9TG5DKFqgLpoDkTvxF+yYia3oeWA6LsYjFrsxDcK
   2nbhvZWF9zezLA6FPCAtTHS/k3Yi9KoRN0NJkw==
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=dkim; d=floridaarsonseminar.com;
 b=CIKzbBSwCbogRQ0WOMtk8qepVwMKeqA4f41N+wenA9D9RljfgzX/XpJHrNk1zOtfrYVudYNkDGC7
   tCOcwZjlDgqSN5pastFE/r+9olhdainqek61pmmvDka1Kjw9GQvGl2Y5Bfa6krwD7SmGETHBs0oN
   +QC21qb+ohcTzviDjwqHrmz+g6Kp/coGx0Nw0p+DljZlCroZq1MLAB4cJBgrs6Yb/1RhmInzFa3L
   ieHgRC3K8zloWdIYkv1+QaCoTA9MvXzEDRITW+D2qKYnDydIOqBt9JUejiZrtsjxvTwc/I0DxIel
   zoRBDWIZQksrLHvxiEzaNPgGvBwBejBWTokbPQ==;
Reply-To: ayvamustafa22@gmail.com
From:   rae.leo@floridaarsonseminar.com
To:     netdev@vger.kernel.org
Subject: Hello
Date:   10 Apr 2022 13:55:17 +0200
Message-ID: <20220410135517.560A32B4ECC5208D@floridaarsonseminar.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_MSPIKE_BL,
        RCVD_IN_MSPIKE_L3,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.9 RCVD_IN_MSPIKE_L3 RBL: Low reputation (-3)
        *      [85.202.169.206 listed in bl.mailspike.net]
        *  1.3 RCVD_IN_BL_SPAMCOP_NET RBL: Received via a relay in
        *      bl.spamcop.net
        *      [Blocked - see <https://www.spamcop.net/bl.shtml?85.202.169.206>]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [ayvamustafa22[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 RCVD_IN_MSPIKE_BL Mailspike blacklisted
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sauda=C3=A7=C3=B5es ,

Estou procurando um parente do meu falecido cliente Sr. Robert,=20
que perdeu a vida devido =C3=A0 doen=C3=A7a do Coronav=C3=ADrus, que ele=20=

contraiu durante sua viagem de neg=C3=B3cios na China. Eu sou seu=20
advogado pessoal e estou procurando seus parentes mais pr=C3=B3ximos,=20
entrei em contato com voc=C3=AA para trabalhar comigo na garantia da=20
transfer=C3=AAncia de um fundo fiduci=C3=A1rio, quatro milh=C3=B5es,=20
quatrocentos e vinte mil d=C3=B3lares, legado por meu falecido=20
cliente.

Entre em contato comigo imediatamente para obter mais=20
informa=C3=A7=C3=B5es.

esperando
Mustaf=C3=A1 Aivaz
