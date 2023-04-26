Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980656EFE2C
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242693AbjD0AJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240955AbjD0AJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:09:24 -0400
Received: from mail.heimpalkorhaz.hu (mail.heimpalkorhaz.hu [193.224.51.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4145C3A92
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 17:09:23 -0700 (PDT)
Received: from mail.heimpalkorhaz.hu (localhost [127.0.0.1])
        (Authenticated sender: alexandra.nagy@heimpalkorhaz.hu)
        by mail.heimpalkorhaz.hu (Postfix) with ESMTPA id 1FC0E38357940D;
        Thu, 27 Apr 2023 01:48:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.heimpalkorhaz.hu 1FC0E38357940D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heimpalkorhaz.hu;
        s=default; t=1682552896;
        bh=W6ZSce0cCVgkn0l95t889AY595zUPLw5BzNOdwdHQs8=;
        h=Date:From:To:Subject:Reply-To:From;
        b=Ik6+e0jYg7HjxHClzzO5azafRjfaa+PNACW3wsMxvftGfqtt77O1DKoUmAo/3230Z
         5DjVt2xhKPUNNN39ahlqPIce1uWdsj6S01V+mYvyplahigsTVRHPLs6T0nX3nYL09V
         LHE+WvVCscUES/9HXRYNv5qG2Z9nM/0R9FD86ZrPQt+SmTy8GKfOIhVwZqr9EVa9n3
         rrmymTvLeGjtCbaC7V98nQ87jJEMcu8/0EHAbiHkOIxXSFyTahljAiFIBY69zh7o1g
         98FKOc0B7W8txx/eYxk8z7N0aLPVtmUlMe9SFhoxcjSlaBJTnBiOYgGTt8g0k5rD2c
         9b0hpFNbAXeIQ==
MIME-Version: 1.0
Date:   Thu, 27 Apr 2023 07:48:15 +0800
From:   "M.K" <mk@heimpalkorhaz.hu>
To:     undisclosed-recipients:;
Subject: =?UTF-8?Q?=E4=BD=A0=E5=A5=BD=E9=99=BD=E5=85=89?=
Reply-To: kmarion709@gmail.com
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <988f980bf597a815035daa64d9b440a5@heimpalkorhaz.hu>
X-Sender: mk@heimpalkorhaz.hu
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1FC0E38357940D
X-Spamd-Result: default: False [4.31 / 20.00];
        R_UNDISC_RCPT(3.00)[];
        FORGED_RECIPIENTS(2.00)[m:,s:nerocxhe@gmail.com,s:nertil_barjami@hjotmail.com,s:nertil_barjami@hotmail.com,s:neruhime77@hotmail.co.jp,s:neruutis@gmail.com,s:nerv1236@163.com,s:nervefactor@yahoo.com,s:nerwus14@wp.pl,s:neryla.jolly@sydney.edu.au,s:nes_lopes@yahoo.com,s:nesetos@hotmail.com,s:nesh@dspiso.com,s:neshay.mclean@yahoo.com,s:neshinarus@gmail.com,s:neshinava@bellsouth.net,s:nesidara@gmail.com,s:nessa.aguirrem@hotmail.com,s:nessarianne@gmail.com,s:nest@nestedu.com.tw,s:nestanick@126.com,s:nesterenko_pawel@rambler.ru,s:nestle@o2.pl,s:nestorel@gmail.com,s:nestorgonlaza97@hotmail.com,s:net-neighbour@163.com,s:net1980eagle@126.com,s:net688158822@126.com,s:net8686@126.com,s:net_bloom12@yahoo.com,s:net_wei@126.com,s:netdev@vger.kernel.org,s:nete_ase_63529347@126.com,s:netease2005aie@vip.163.com,s:netease8866@126.com,s:netease_6107@vip.163.com,s:netease_sheguangming@126.com,s:netherking24@gmail.com,s:netinfog@21cn.com,s:netjingchao@163.com,s:netliu0221@126.com,s:neto-bolado@hotmail.co
 m,s:netorusso@hotmail.com,s:netplaza1979@yahoo.co.jp,s:netserver@163.com,s:netten@bellsouth.net,s:nettermann2002@hotmail.com,s:networth@bellsouth.net,s:neucirenefortaleza@gmail.com,s:neudwsyu@sohu.com,s:neueee73x@sohu.com,s:neunils@web.de,s:neusesser@web.de,s:neutro_30@hotmail.com,s:nev.jen@kinect.co.nz,s:nevarezjunjun@gmail.com,s:nevbcijlq@21cn.com,s:nevenacalovska@gmail.com,s:never.666@hotmail.com,s:neveragain329@yahoo.com,s:neverfaddinglove@126.com,s:neverici@email.cz,s:neverlandg@163.com,s:neversaydie-alfa@163.com,s:neves0202@gmail.com,s:neves_hbs@hotmail.com,s:nevii1@hotmail.com,s:nevjan@mail.ru,s:nevrana@msn.com,s:nevskiy_nik@mail.ru,s:new-master@163.com,s:newagegilgamesh@gmail.com,s:new_goon_63@hotmail.com,s:new_worlds_edge@yahoo.com,s:newallan8@139.com,s:newani@163.com,s:newbank_jia@163.com,s:newbauerj@hotmail.com,s:newboyzhe@hotmail.com,s:newcal_ins@yahoo.com,s:newcastle@sina.com,s:newcastle@ukec.com,s:newcastlechenlong@gmail.com,s:newclowns@mail.ru,s:newdelhi@bridgeblueglo
 bal.com,s:newera133@126.com,s:newfobia@mail.ru,s:newgenius19840807@msn.com,s:newhopyan@hotmail.com,s:newhorizons19@gmail.com,s:newjj@rhodes.edu,s:newkingship@sohu.com,s:newland@ncgrp.com,s:newlifeinpeace@yahoo.com.cn,s:newlove12345@163.com,s:newmaill@inbox.ru,s:newmother86@gmail.com,s:neworientalnz@gmail.com,s:newoz@ms6.hinet.net,s:newpika022@gmail.com];
        GENERIC_REPUTATION(-0.59)[-0.58792666917281];
        MIME_GOOD(-0.10)[text/plain];
        TAGGED_RCPT(0.00)[];
        FROM_EQ_ENVFROM(0.00)[];
        RCVD_COUNT_ZERO(0.00)[0];
        MIME_TRACE(0.00)[0:+];
        FROM_HAS_DN(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[gmail.com,hotmail.com,163.com,yahoo.com,wp.pl,bellsouth.net,126.com,rambler.ru,vip.163.com,21cn.com,yahoo.co.jp,sohu.com,web.de,email.cz,mail.ru,msn.com,139.com,sina.com,yahoo.com.cn,inbox.ru,188.com,gmx.li,yahoo.cn,yandex.ru,t-online.de,live.cn,qq.com,yahoo.com.tw,yahoo.co.nz,tom.com,naver.com,aol.com,laposte.net,freemail.hu,yahoo.ie,icloud.com,china.com,uol.com.br,wanadoo.fr,libero.it,virgilio.it,ymail.com,gmx.de,hotmail.it,freenet.de,me.com,live.com.au,live.com,windowslive.com,hotmail.co.uk,live.nl,yahoo.it,live.co.uk,comcast.net,att.net,gmx.net,arcor.de,hotmail.es,gmx.at,hotmail.fr,live.fr,rocketmail.com,live.it,katamail.com,yahoo.co.uk,orange.fr,free.fr,sfr.fr,outlook.it,bk.ru,list.ru,seznam.cz,zipmail.com.br,alice.it,abv.bg,yandex.ua,yahoo.de,live.de,tut.by,yahoo.es,outlook.de,terra.com.br,yahoo.gr,mac.com];
        TO_DN_ALL(0.00)[];
        MID_RHS_MATCH_FROM(0.00)[];
        RCPT_COUNT_ONE(0.00)[1];
        REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
        FREEMAIL_REPLYTO(0.00)[gmail.com];
        HAS_REPLYTO(0.00)[kmarion709@gmail.com]
X-Rspamd-Server: mail.heimpalkorhaz.hu
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

你好呀，

很抱歉打擾您並侵犯您的隱私。 我是單身，孤獨，需要一個關懷，愛心和浪漫的伴侶。

我是一個暗戀者，想探索更多了解彼此的機會。 我知道這樣聯繫你很奇怪，希望你能原諒我。 我是一個害羞的人，這是我知道我能引起你注意的唯一方式。 
我只是想知道你的想法，我的本意不是要冒犯你。 我希望我們能成為朋友，如果那是你想要的，儘管我希望不僅僅是朋友。 
我知道你有幾個問題要問，我希望我能用一些答案來滿足你的一些好奇心。

我相信“對於世界來說，你只是一個人，但對於特別的人來說，你就是全世界”這句話。 我想要的只是來自一個特殊伴侶的愛、浪漫的關懷和關注，我希望是你。

我希望這條消息將成為我們之間長期溝通的開始。 感謝您回复此消息，因為這會讓我很高興。


擁抱，

你的秘密崇拜者。
