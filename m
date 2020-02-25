Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E289A16BBD0
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 09:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgBYI1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 03:27:04 -0500
Received: from sonic307-20.consmr.mail.sg3.yahoo.com ([106.10.241.37]:37891
        "EHLO sonic307-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729130AbgBYI1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 03:27:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1582619220; bh=jYrCH7KfTQEGtBqWcsX3n0y6XjBD3dqgMTcABJT9ys8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=D4tOZBoW0Ei1ZcYW7XvS/9W3nLj2qooYqsVWNKbwwJfjknGedDVFCzEgEOpRzO8L6xrg8giomCBevxEVF4LaCBlgaF0n5/LoV6AKuxIKEa2iPrByY08scnT0mxEa8gkkQu05kywvIpT0xNYLfZwh8df4pY69ETgOcfpy7k2wGvyp1pbjNw/jE+EbLQn4ATydjyyJzPSYfnCDmTcsB3yl/Azjsg3wRD4u0VLNVnu3Dnu4u3iaIf83PbxLN3D+ADlqtsn30fBj6o0+hf2e5hTTFgAsOZ6G1EWeRmPKwvVMqo0XisWBmckphgpIz9X2tYpQ6Mt64IWVXgH1vCi324erVQ==
X-YMail-OSG: ycXpPaoVM1n_lUut85lpp.RlLOz80ph7aWmBYfnLnxG8nEttTKHGdNXR0BR..kZ
 N4rqGNFrudGyxWYygEsvIyHE0QPj4lzKKtAf5yS1WiTZFiQNeDve3UufyLxz_FPssvIoipEyeTqB
 sqxjbuplXZMOw0iaTgSNCpLkJOzQRurjmx3WoIL7DzMSDt3iDYaMeDSVPSz26EGCxkqgOkcsibpC
 W0AipuIPYqKcEo9eyp8NCiJjoEzNndAqO5AE56T.C1H7aqfRUCh6vlzSMsozK7L2AlUQOUH4WSxl
 n0AyOwK6Escx9vjjjDDwgt4vcFb28K87ND.ohA.epcUXf7TWE_wmIDo4aKhqLbkqP0A0ZEoFDx89
 dFxQm5M0_Uyd2NB5K_Hf8jMXTQRRoZsImmrrweO4AzQ_aFnMFbQJOSP39VCM81HomAPMja9gG71T
 a1E55BMhntone6odSMDbQSDzf4qCwenxo1C.mKHRiZYYWtUH9YqRhERdQkelbpxoMpUDWqJjDwEO
 8uEt71NdfV185FPR89WeDLUSHHKIISiY07Yy1U4QCHrSwPSmqTdvOK3JblEQaIJOv.Lx7wX5Dn2W
 PczysmdhtP.wPCxSLdpJTN.bF4bdrWIfiXP6hESw6iVmfrWwGGGQoPY9WPloMv0Mbfr1G6F5JrAD
 Yk9mGyKFQqSyskFj.H_Q9IL8CMKInQg974JC8sc.yXCc2dvuhXAbQoJylYLAZcAj3qo9wVzx9YrW
 8PN4Yxm4uGUiBXKmXBhm1WViu1jgZId1ZUXn38pMl99idWj4sytc5vzKEkJFK0v0CiIcLpuZLcw0
 nlA94xnpA2aW472tC98zNjieB3EPas_UjLADrWXf48QR6I8GcmrUunnpL.A7HICJBzTfvzy7GQ4W
 fQx6ItsK5skXoc73Ypdb2QQql414YGdj0cSwtvIEr4yHkHCScedg63xj0p9rbnQLXNVlPx8Tai4j
 Ake4DD93J1.R3ESV0CGOlxxSB8_CwmSH_4s5p4fKidbYQdttCf0peqDF3hRbBhcfAH7ctdafCw3j
 BlU5Pw22KIM_Lz7uCME0zwafRiEfJPQvMIYFsZE75J3zI9kgpl01kwD8GayOB7sTWmOxES_.HHyd
 rZ5yXz7BeWGxzdDZu_PLtLsdIw4NasL13Ig52Nv1uxlpM4.vDkQ86wblY01QfL7EZVVCUtXNpp6G
 w4XNXiUn.ly52xdgHD3W3ndJ3nsNBP8fycnLa41HGg2zJ8W2l0rjYnS8DwGKvgQ0BM3F7_CqUy34
 W6cGLuHQ1n3.5sP1EKbha8ETl0HzimShN1jejlD.PfpjhRRA4JGN5X9ge7rgiwOo5ipXWV2zFx7i
 .O1eGRlexyJDIz3DfeAHulvh32cnCfkErvjMuyDA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.sg3.yahoo.com with HTTP; Tue, 25 Feb 2020 08:27:00 +0000
Date:   Tue, 25 Feb 2020 08:26:56 +0000 (UTC)
From:   Mrs Aisha Al-gaddafi <mrsaishagaddafi18@gmail.com>
Reply-To: mrsaishaalgaddafi09@gmail.com
Message-ID: <1534436601.183758.1582619216427@mail.yahoo.com>
Subject: Greetings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1534436601.183758.1582619216427.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15302 YMailNodin Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36 AVG/79.0.3064.81
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend,

Greetings and Nice Day.

Assalamu Alaikum

May i=C2=A0 use this medium to open a mutual communication with you seeking=
 your acceptance towards investing in your country under your management as=
 my partner, My name is Aisha=C2=A0 Gaddafi and presently living in Oman, i=
 am a Widow and single Mother with three Children, the only biological Daug=
hter of late Libyan President (Late Colonel Muammar Gaddafi) and presently =
i am under political asylum protection by the Omani Government.

I have funds worth "Twenty Seven Million Five Hundred Thousand United State=
 Dollars" -$27.500.000.00 US Dollars which i want to entrust on you for inv=
estment project in your country.If you are willing to handle this project o=
n my behalf, kindly reply urgent to enable me provide you more details to s=
tart the transfer process.
I shall appreciate your urgent response through my email address below:

mrsaishaalgaddafi09@gmail.com

Best Regards
Mrs Aisha Gaddafi
