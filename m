Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2546E8A22
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjDTGJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbjDTGJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:09:08 -0400
Received: from mail.heimpalkorhaz.hu (mail.heimpalkorhaz.hu [193.224.51.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCA6469B
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:09:05 -0700 (PDT)
Received: from mail.heimpalkorhaz.hu (localhost [127.0.0.1])
        (Authenticated sender: lmateisz@heimpalkorhaz.hu)
        by mail.heimpalkorhaz.hu (Postfix) with ESMTPA id 21187384A4D065;
        Thu, 20 Apr 2023 01:40:33 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.heimpalkorhaz.hu 21187384A4D065
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heimpalkorhaz.hu;
        s=default; t=1681947633;
        bh=SFPaiUyYqM5Iz1wf9UVYSHssSttYIu6SPYgIrz5naIQ=;
        h=Date:From:To:Subject:Reply-To:From;
        b=Z74k1GY8wgSkypKYwaJzla7vaXp+UK3NyAIIalzgRkzQa0VxgW2Ysg244z+h1N7sT
         eOhWJKytNqG55xCd+6vdDRG+5qpOM14spOoksWAiXwNn1Y4vTVyromMaLkYBfwOQH9
         qvPBIt1OovvK71wVTUMjByA0JeDI1erUIP2pi+DG56k4ay303b9LfzhWexZxERlm2c
         HidAQn276YuNbBU72CppBX1fP4JA63W/uifF5CxwFJYFizF0OoG6zEhzbWEZ4nvoJD
         jWmo1T6JhcaENyth1Ho02Nh7q2UgGdbGuHxDvGjnWZiEvzyogkllRTLt4l2p5U5xYY
         EW18ABKnp+eDw==
MIME-Version: 1.0
Date:   Thu, 20 Apr 2023 07:40:32 +0800
From:   mk <mk@heimpalkorhaz.hu>
To:     undisclosed-recipients:;
Subject: Hej solsken
Reply-To: marionn.k99@gmail.com
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <54df1ae759c1d690fb560c03b3244a63@heimpalkorhaz.hu>
X-Sender: mk@heimpalkorhaz.hu
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [5.41 / 20.00];
        R_UNDISC_RCPT(3.00)[];
        FORGED_RECIPIENTS(2.00)[m:,s:mrsaint@mrsaint.se,s:mrsford@telia.com,s:mrsnoid@snoid.se,s:mrtandersen@hotmail.com,s:mruefi@hotmail.com,s:msmariasundin@gmail.com,s:msa@communication.microsoft.com,s:msergo@erols.com,s:msgs@PoochGazzara.site,s:msgs@RileyGarson.space,s:msgs@RoseyGarlin.space,s:msgs@SethGandolfini.space,s:msgs@ShonGamble.xyz,s:msgs@ShulerGambill.icu,s:msgs@TehranGabrus.icu,s:msgs@ThurstonGabel.xyz,s:msgs@ramonbickford.bid,s:mshf@handboll.rf.se,s:mshf@sormland.rf.se,s:msn.sudd@hotmail.com,s:msonlineservicesteam@microsoftonline.com,s:mspe@clark.net,s:mstensberg@gmail.com,s:mstrandfors@hotmail.com,s:msundholm@hotmail.com,s:msv@bjornomsv.se,s:mswideland@gmail.com,s:mt@whisperingnights.com,s:mtsullberg@gmail.com,s:mua@tinet.cat,s:mudhoneys@bahnhof.se,s:mueller.jason@t-online.de,s:mufor@maltanet.net,s:muhamud.hassan.omar@lundby.goteborg.se,s:mujaga10@hotmail.com,s:mukhlisshamon@hotmail.se,s:mullback@icloud.com,s:mullback@ingelsvag.com,s:mulleman62@hotmail.com,s:multimood@algone
 t.se,s:munin30@gmail.com,s:musatransfer@gmail.com,s:museu@valls.cat,s:musicalskennel@gmail.com,s:musicano@swipnet.se,s:musicavalls@tinet.cat,s:musicco@op.pl,s:muskelknutenkarlstad@gmail.com,s:musketoreniursvik@gmail.com,s:mustafa-selim@uiowa.edu,s:mustafa.jamil@hule.harryda.se,s:mustafa@hotmail.se,s:mustafa@mecsan.com.tr,s:mv11@tele2.se,s:mv@va-trader.com,s:mvg@mnw.se,s:mvilandt@hotmail.com,s:mw13@scandinavia-giveaways.com,s:mw14@scandinavia-giveaways.com,s:mw@9000.org,s:mw@ica-testers.com,s:mw@mail.news-port247.com,s:mw@nordicrefit.se,s:mw@scandinavia-giveaways.com,s:mw@trackbase1.com,s:mxxxxxy@bahnhof.se,s:my.falk@orebroll.se,s:my.falk@regionorebrolan.se,s:myckling@msn.com,s:mydhlfreight@dhl.com,s:myggan0319@gmail.com,s:mykologi@hotmail.com,s:mylouskennel@gmail.com,s:mynameis@h-148-208.a328.priv.bahnhof.se,s:myranirene@gmail.com,s:mysamsung@noilc.pi74g.cchipmunk.eu,s:mysamsung@rxk5zmvtqj.ti2mk.8chameleon.eu,s:mysamsung@v2a1k.lyreo.dsnake.eu,s:mysia@live.se,s:mzeiler@zuht.tiho-hann
 over.de,s:mzhunio@camposantosantaana.com,s:n.gudmundsson@bahnhof.se,s:n.ia@skynet.be,s:n.ivansson@hotmail.com,s:nivarbjornson@gmail.com,s:n.j.hubbard@hud.ac.uk,s:n.levin@uq.edu.au,s:n.mueller-erben@utanet.at,s:n.stom@hotmail.com,s:n.vilhelmsson@telia.com,s:n.welin-berger@telia.com,s:n@a1fouroutown.men,s:n@a1fouroutpull.men,s:n@bahnhof.se,s:n@ssc.se,s:n_mattsson@telia.com,s:naarh001@tea.edu.stockholm.se,s:nabben2001@gmail.com,s:nackanaprapaten@gmail.com];
        R_MIXED_CHARSET(1.10)[];
        GENERIC_REPUTATION(-0.59)[-0.58890809052871];
        MIME_GOOD(-0.10)[text/plain];
        RCVD_COUNT_ZERO(0.00)[0];
        MIME_TRACE(0.00)[0:+];
        FROM_EQ_ENVFROM(0.00)[];
        TO_DN_ALL(0.00)[];
        RCPT_COUNT_ONE(0.00)[1];
        REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
        FROM_HAS_DN(0.00)[];
        MID_RHS_MATCH_FROM(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[hotmail.com,gmail.com,t-online.de,icloud.com,op.pl,msn.com,live.se,utanet.at,post.com,orange.fr,me.com,live.com,outlook.com,HOTMAIL.COM,yahoo.com,gmx.com,spray.se,compuserve.com,yahoo.se];
        FREEMAIL_REPLYTO(0.00)[gmail.com];
        TAGGED_RCPT(0.00)[];
        HAS_REPLYTO(0.00)[marionn.k99@gmail.com]
X-Rspamd-Queue-Id: 21187384A4D065
X-Rspamd-Server: mail.heimpalkorhaz.hu
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hej min kära,

Jag är ledsen att jag stör dig och inkräktar på din integritet. Jag är 
singel, ensam och i behov av en omtänksam, kärleksfull och romantisk 
följeslagare.

Jag är en hemlig beundrare och skulle vilja utforska möjligheten att 
lära mig mer om varandra. Jag vet att det är konstigt att kontakta dig 
på det här sättet och jag hoppas att du kan förlåta mig. Jag är en blyg 
person och det är det enda sättet jag vet att jag kan få din 
uppmärksamhet. Jag vill bara veta vad du tycker och min avsikt är inte 
att förolämpa dig. Jag hoppas att vi kan vara vänner om det är vad du 
vill, även om jag vill vara mer än bara en vän. Jag vet att du har några 
frågor att ställa och jag hoppas att jag kan tillfredsställa en del av 
din nyfikenhet med några svar.

Jag tror på talesättet att för världen är du bara en person, men för 
någon speciell är du världen, allt jag vill ha är kärlek, romantisk 
omsorg och uppmärksamhet från en speciell följeslagare som jag hoppas 
skulle vara du.

Jag hoppas att detta meddelande kommer att bli början på en långsiktig 
kommunikation mellan oss, skicka bara ett svar på detta meddelande, det 
kommer att göra mig glad.

Puss och kram,

Marion.
