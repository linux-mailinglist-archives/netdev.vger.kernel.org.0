Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6157E6E878D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjDTBpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDTBpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:45:03 -0400
X-Greylist: delayed 4247 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Apr 2023 18:45:01 PDT
Received: from mail.heimpalkorhaz.hu (mail.heimpalkorhaz.hu [193.224.51.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F52430EA;
        Wed, 19 Apr 2023 18:45:01 -0700 (PDT)
Received: from mail.heimpalkorhaz.hu (localhost [127.0.0.1])
        (Authenticated sender: lmateisz@heimpalkorhaz.hu)
        by mail.heimpalkorhaz.hu (Postfix) with ESMTPA id D0F3B384A1BDDF;
        Thu, 20 Apr 2023 01:59:06 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.heimpalkorhaz.hu D0F3B384A1BDDF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heimpalkorhaz.hu;
        s=default; t=1681948747;
        bh=0SvEQ2qxWUr6CAhQeUp6fE6iKpfYW2PiFDnjTXdqJls=;
        h=Date:From:To:Subject:Reply-To:From;
        b=gMPj4snOI5ESUdbEhfkXPRpZwvIV/7HnohgSWn5+ZIArdbtl5ckJ4Cb1pVUTHfXpa
         uOedmA8uaqDb3CkDmOXhWIVsNnIuyZzKpM45ewmmd+miCyeYBFNoE8RZxOZxheZA4Z
         mSjQy4y6UbTs0Tu7nvwUTlLrDsKQhAnXwE4w8OT/zqAzDPZ3PgGIUhV0q8+U7rN7eL
         SfxgjxJuB/q14VlyLe1xBKXZet2qVj7m64kQHyuGMGPVZFey2sR8ZNPTxVk6PodR9V
         Qy+azuqOCn5VdVuqwnM8YO2mGrEPEDuVj6IEJ1hHp1mshS5eEM0xX3sehEY3oMq4lh
         dQGSNSUcAycLg==
MIME-Version: 1.0
Date:   Thu, 20 Apr 2023 01:59:06 +0200
From:   MK <mk@heimpalkorhaz.hu>
To:     undisclosed-recipients:;
Subject: Hallo zonneschijn, hoe gaat het?
Reply-To: marion.k07081@gmail.com
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <5e720fb798e6f8d100eb1b63975da9f6@heimpalkorhaz.hu>
X-Sender: mk@heimpalkorhaz.hu
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [5.46 / 20.00];
        R_UNDISC_RCPT(3.00)[];
        FORGED_RECIPIENTS(2.00)[m:,s:ria.engels@upcmail.nl,s:riandre56@upcmail.nl,s:s.marcus@upcmail.nl,s:s.natoewal@upcmail.nl,s:s.ritoe@upcmail.nl,s:s.zelst@upcmail.nl,s:secretariaat.zwcdts@upcmail.nl,s:sonnevelt@upcmail.nl,s:svennauta@upcmail.nl,s:t.adrichem@upcmail.nl,s:t.buitenhuis5@upcmail.nl,s:t.michelbrink@upcmail.nl,s:thea.g@upcmail.nl,s:v.klasens@upcmail.nl,s:w.angel7@upcmail.nl,s:w.maronier@upcmail.nl,s:w.stevens22@upcmail.nl,s:w.zweijpfenning@upcmail.nl,s:waza@upcmail.nl,s:wielle695@upcmail.nl,s:wimels@upcmail.nl,s:yvonne.hemert@upcmail.nl,s:d.blokland88@upcmail.nl,s:a.wierda4@upcmail.nl,s:r.van.emmerik@upcmail.nl,s:Ruisch06-83202551sruisch@upcmail.nl,s:Ruisch06-46358145mruisch@upcmail.nl,s:7w.heijdacker@upcmail.nl,s:a.zegers11@upcmail.nl,s:rufin.yune@upf.pf,s:info@upplevnordanstig.se,s:buzzwurks@usa.net,s:info@usaeconnect.com,s:test@user.nl,s:rawnar@users.sourceforge.net,s:info@uskeatsen.nl,s:kgpadilh@usp.br,s:vian@usp.br,s:jo8@usvhercules.nl,s:aare.kasemets@ut.ee,s:olli.ylonen
 @uta.fi,s:a.reite@utanet.at,s:ph.lorentz@utex.ma,s:andyz@utexas.edu,s:external@utn.stjr.is,s:postur@utn.stjr.is,s:j.nganji@utoronto.ca,s:odlc@utoronto.ca,s:nico@utrecht-promotions.nl,s:duurzame-energierijnenburg@utrecht.nl,s:j.gootzen@utrecht.nl,s:johan.simon@utrecht.nl,s:k.vandenbos@uu.nl,s:m.asadpoor@uu.nl,s:n.h.g.devries@uu.nl,s:o.h.klungel@uu.nl,s:Y.Zhou1@uu.nl,s:c.vanewijk@uva.nl,s:e.s.bergvelt@uva.nl,s:g.m.m.kuipers@uva.nl,s:anne.vermeer@uvt.nl,s:RWarne@uvu.edu,s:n.schiphouwer@uvvz.nl,s:info@uwe.be,s:mthuys@uwnet.nl,s:draaisma@uwnwt.nl,s:alexontwerpt@uwsieraad.nl,s:veerle.taelman@uz.kuleuven.be,s:bart.op.de.beeck@uza.be,s:marie-jose.tassignon@uza.be,s:paul.parizel@uza.be,s:wouter.vaneerdeweg@uza.be,s:05susanne.bohler@uzbrussel.be,s:13ursula.vandeneede@uzbrussel.be,s:72ida.flament@uzbrussel.be,s:bart.depreitere@uzleuven.be,s:Karel.Vankeer@uzleuven.be,s:rik.willems@uzleuven.be,s:sofie.coenen@uzleuven.be,s:roland@uzn.nl,s:carla@v-breemen.demon.nl,s:alex@v2.nl,s:accounthaube@v7ver
 sand.de,s:Jeroen@vabnethems.nl,s:riem@val.be,s:auquiere@valbiom.be,s:willy@van-roemburg.nl,s:info@vanbaallingerie.nl,s:astrologie@vanblommestein.nl,s:marnix@vandekerkhove.be,s:infol@vandepoel-expertise.be,s:roel@vanderdrift.nl,s:wilco@vandermerch.net,s:Francoise@vanderwaals01.demon.nl,s:vandort@vandort.com,s:matthias@vanduysen.be,s:CARLA@VANENTHOVEN.NL,s:info@vanerck.be,s:bureau@vanhentenrijk.be];
        SUBJECT_ENDS_QUESTION(1.00)[];
        GENERIC_REPUTATION(-0.59)[-0.58872629738287];
        BAYES_SPAM(0.15)[64.09%];
        MIME_GOOD(-0.10)[text/plain];
        FROM_EQ_ENVFROM(0.00)[];
        MIME_TRACE(0.00)[0:+];
        RCVD_COUNT_ZERO(0.00)[0];
        TO_DN_ALL(0.00)[];
        RCPT_COUNT_ONE(0.00)[1];
        REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
        FROM_HAS_DN(0.00)[];
        MID_RHS_MATCH_FROM(0.00)[];
        FREEMAIL_ENVRCPT(0.00)[upcmail.nl,usa.net,utanet.at,verizon.net,VERIZON.NET,versatel.nl,videotron.ca,vip.onet.pl,virgilio.it,virgin.net,vodafonethuis.nl,wanadoo.fr,web.de,windowslive.com,worldnet.att.net,wp.pl,xs4all.nl,XS4all.nl,xtra.co.nz,ya.ru,yahoo.ca,Yahoo.Ca,yahoo.co.in,yahoo.co.jp,yahoo.co.nz,yahoo.co.uk,yahoo.com,YAHOO.COM,yahoo.com.ar,yahoo.com.au,yahoo.com.br,yahoo.com.ph,yahoo.com.sg,yahoo.com.tw,yahoo.de,yahoo.dk,yahoo.es,yahoo.fr,yahoo.gr,yahoo.it];
        FREEMAIL_REPLYTO(0.00)[gmail.com];
        HAS_REPLYTO(0.00)[marion.k07081@gmail.com]
X-Rspamd-Queue-Id: D0F3B384A1BDDF
X-Rspamd-Server: mail.heimpalkorhaz.hu
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Het spijt me u te storen en uw privacy te schenden. Ik ben vrijgezel,
   eenzaam en heeft behoefte aan een zorgzame, liefdevolle en romantische 
metgezel.

Ik ben een geheime bewonderaar en zou graag de mogelijkheid willen 
onderzoeken
leer meer over elkaar. Ik weet dat het vreemd is om contact met je op te 
nemen
op deze manier en ik hoop dat je me kunt vergeven. Ik ben een verlegen 
persoon en
dit is de enige manier waarop ik weet dat ik je aandacht kan trekken. Ik 
wil gewoon
om te weten wat je denkt en het is niet mijn bedoeling om je te 
beledigen.
Ik hoop dat we vrienden kunnen zijn als je dat wilt, hoewel ik dat zou 
willen
om meer te zijn dan alleen een vriend. Ik weet dat je een paar vragen 
hebt
vraag het en ik hoop dat ik met een paar iets van je nieuwsgierigheid 
kan bevredigen
antwoorden.

Ik geloof in het gezegde dat 'voor de wereld ben je maar één persoon,
maar voor een speciaal iemand ben jij de wereld'. Alles wat ik wil is 
liefde,
romantische zorg en aandacht van een speciale metgezel die ik ben
in de hoop dat jij dat zou zijn.

Ik hoop dat dit bericht het begin is van een lange termijn
communicatie tussen ons, stuur gewoon een antwoord op dit bericht, it
zal me gelukkig maken.


Knuffels en kussen,

Marion.
