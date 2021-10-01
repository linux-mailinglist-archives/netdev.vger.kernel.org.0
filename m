Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA741F732
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355830AbhJAWDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355808AbhJAWDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:03:17 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F87C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 15:01:32 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e7so10628244pgk.2
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 15:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Y2F9tIAyLMuMdvZ+xZbB5A4lCV2UGNUjjsvsd+NvfA8=;
        b=nLwnCcCpsbhh9tlYkzrR3eqn/SxV/0UQ7ry/IyoWpP7kiyQuoekJHTPaSnpSp+lMUB
         N3dcGgDYZog4DWLGb1mjU5KXe0ntZ6sqjs+HLnaOcjriEbGgjGBiNw3OFEBtqoZx2q2J
         bvDH0pozvbX8aWTHSCAGKHQ/IHtPuKMRxpAh80EAvmqlGx0s3qNgZtw7Z3wPBOxpBl+N
         toI3xe7XMhptXGKWahLqR1UNNFYRYlg6sIlkM5Oe1RazDHdvtTJYYA6C+3tKU4VNGeIE
         MdhjuAMC1IeHC62ir1y8UFs2rsIto1T1bGKwC3W/isOmsMjmzC7XcHouBIgzl/BaMi+W
         VkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=Y2F9tIAyLMuMdvZ+xZbB5A4lCV2UGNUjjsvsd+NvfA8=;
        b=gRy5j4E/jqZm2hSDWgOF/At5uut3Dc0vG95wndldVa/5CUQSq3gbK97c2UHVr7Qu5y
         QvkBZSY1vmtHhss3qxF2MGbEZiWaYbU9xUHW9ZaaMWup6846gWIXVa4mPGHBK/3Ymv6E
         nLZu6Y6UoWJbuC3lmTjxMJjPKl5UpJ4PiLET492zfzARr/6k09N4g+wsRPruEk/7TbO2
         dBfQIY/xkHCCQJ7s3mrKA+QgJ+hUzEePkUn5+TTWdNgVSqSHAHHHskTH0Rt9F4hArTnp
         V54YrbSBeCBb3AJHoub9wvuRvRq4U67KgqGMl3d21AHynlsEaxU1jGi+k3e0qzmuhpuC
         ppzQ==
X-Gm-Message-State: AOAM530oOatfg+ps9XOm12B4RI8RNtcSXwQ0tBPkTsibdSB8+i/8YtIC
        v/kQRGAa6b+lYadsJngYq4zCUszdg3NXRl5UK7U=
X-Google-Smtp-Source: ABdhPJzyCpO4XLPY9ttq+S4ru1eYmEZehaeTbSCfHSxdA78CmOt0CYgyWHwK3dG17V092G/nwIBPiO5GyfkMDuzsEWw=
X-Received: by 2002:a63:530e:: with SMTP id h14mr297218pgb.279.1633125692157;
 Fri, 01 Oct 2021 15:01:32 -0700 (PDT)
MIME-Version: 1.0
Sender: manuellawarlordibrahim7@gmail.com
Received: by 2002:a05:6a10:1d8f:0:0:0:0 with HTTP; Fri, 1 Oct 2021 15:01:31
 -0700 (PDT)
From:   manuella warlord ibrahim <manuellawarlordibrahim@gmail.com>
Date:   Fri, 1 Oct 2021 15:01:31 -0700
X-Google-Sender-Auth: I2O8iuvA009WiLYrCbLZkA3Z_0k
Message-ID: <CA+ZVOZj04Lq4WKUhkow2C8psrM27bq0v_vY2yVycHup0aqUKBA@mail.gmail.com>
Subject: =?UTF-8?Q?aspetter=C3=B2_di_leggerti=21=21=21?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Carissimo,

So che questa e-mail ti sorprender=C3=A0 poich=C3=A9 non ci siamo conosciut=
i o
incontrati prima di considerare il fatto che ho trovato il tuo
contatto e-mail tramite Internet alla ricerca di una persona di
fiducia che possa aiutarmi.

Sono la signorina Manuella Warlord Ibrahim Coulibaly, una donna di 24
anni della Repubblica della Costa d'Avorio, Africa occidentale, figlia
del defunto capo Sgt. Warlord Ibrahim Coulibaly (alias Generale IB).
Il mio defunto padre era un noto capo della milizia della Costa
d'Avorio. =C3=88 morto gioved=C3=AC 28 aprile 2011 a seguito di uno scontro=
 con
le forze repubblicane della Costa d'Avorio (FRCI). Sono costretto a
contattarvi a causa dei maltrattamenti che sto ricevendo dalla mia
matrigna.

Aveva in programma di portarmi via tutti i tesori e le propriet=C3=A0 del
mio defunto padre dopo la morte inaspettata del mio amato padre. Nel
frattempo volevo viaggiare in Europa, ma lei nasconde il mio
passaporto internazionale e altri documenti preziosi. Per fortuna non
ha scoperto dove tenevo il fascicolo di mio padre che conteneva
documenti importanti. Ora mi trovo attualmente nella Missione in
Ghana.

Sto cercando relazioni a lungo termine e assistenza agli investimenti.
Mio padre di beata memoria ha depositato la somma di 27,5 milioni di
dollari in una banca ad Accra in Ghana con il mio nome come parente
pi=C3=B9 prossimo. Avevo contattato la Banca per liquidare la caparra ma il
Direttore di Filiale mi ha detto che essendo rifugiato, il mio status
secondo la legge locale non mi autorizza ad effettuare l'operazione.
Tuttavia, mi ha consigliato di fornire un fiduciario che star=C3=A0 a mio
nome. Avrei voluto informare la mia matrigna di questo deposito ma
temo che non mi offrir=C3=A0 nulla dopo lo svincolo del denaro.

Pertanto, decido di cercare il tuo aiuto per trasferire i soldi sul
tuo conto bancario mentre mi trasferir=C3=B2 nel tuo paese e mi sistemer=C3=
=B2
con te. Poich=C3=A9 hai indicato il tuo interesse ad aiutarmi, ti dar=C3=B2=
 il
numero di conto e il contatto della banca dove il mio amato padre
defunto ha depositato i soldi con il mio nome come parente pi=C3=B9
prossimo. =C3=88 mia intenzione risarcirti con il 40% del denaro totale per
la tua assistenza e il saldo sar=C3=A0 il mio investimento in qualsiasi
impresa redditizia che mi consiglierai poich=C3=A9 non hai alcuna idea
sugli investimenti esteri. Per favore, tutte le comunicazioni devono
avvenire tramite questo indirizzo e-mail per scopi riservati
(manuellawarlordibrahimw@gmail.com).

La ringrazio molto in attesa di una sua rapida risposta. Ti dar=C3=B2 i
dettagli nella mia prossima mail dopo aver ricevuto la tua mail di
accettazione per aiutarmi,

Cordiali saluti
Miss manuella signore della guerra Ibrahim Coulibaly
(manuellawarlordibrahimw@gmail.com)
