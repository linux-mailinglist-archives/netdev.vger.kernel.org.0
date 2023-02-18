Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867F469BBC1
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 21:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBRURZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 15:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBRURY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 15:17:24 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F7E14220
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 12:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1676751435; i=frank-w@public-files.de;
        bh=Gw36IRUqHtawb/CUkW2qGk9MNKEOzTcoRVma9nYeFy0=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=Kde4cgE2PM+jvOVH2zmg3TgeqVsvIiyJ6pAw2u6whSGPKO1MdOxJQGbPUE4Gz4pDh
         /XbzJDnkiu/J9wLK0VRJOPhNeeaWgQQOZiVx4rKi4xjQeu0PaCSj5Oe1IwjKAV8bhc
         ohBsFawNkLiixUds5e1vsHCiXuxVTsxTPb3lzWfPwZ8x3eFFdi1uAYftS4NA9faQ7i
         v3Hwjfi8QCK1I4baGz5ArTQ54+Qh2XKp3BEj/HphpKe9dgkt++2MCe+E+f2ALuzXhI
         U1Y8nzzXHR15GEZ8LAGyXA2OVjkN9Dai97D1vRbh7WKegkEJ8OiYGqmYvlbQ15KyNd
         OhVjlFmPZyR4A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([217.61.153.5]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N3KTo-1oUbKj2Pha-010MvW; Sat, 18
 Feb 2023 21:17:15 +0100
Date:   Sat, 18 Feb 2023 21:17:15 +0100
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com
Subject: Re: Choose a default DSA CPU port
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
Message-ID: <74F2678E-F8FF-42CE-A76B-9AB759EAC836@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HK++KfaPvU0qr9hAF3grIVd/MsjTU+0SIyGsJeqPEpxpc2hCMXq
 QEMYU77K0r6soKXeIOoZu51kdIuJMfpGlifD4hM98nvjm65AZPgmYVRL4IGYcebG/p4cK2t
 1UxZkCq+TwzZnTLAtWq2OuErBVgc0ZreK11ORTP+XyIi+lDQTz+XsqOFTEHkxhOvv2kSFkP
 z9NFUOBjtf/UQ7n33Uakg==
UI-OutboundReport: notjunk:1;M01:P0:CvzFbqxbfBU=;PED11L5u/BXEKBtWUgbOFZ+2xt/
 2hCjgzK3wXFrqCSEpvqZHB4ha9QSojPGQoBsqVDEgTsvrrazwxw9hv4btoiF5SnQhDiONPmJ+
 69msObLcmUtrsaAkATwB7+LGFW4n9mQpZ9+ekMKgin8II3M6z7Tt1kUA8L/Z/+KUWOR6G4QDt
 V6iU1hDM7mjaDCVcSzGVNZkYeqjjtCbndwkC9U0TYxBFwlDJTya7AUMbutsSCKpBPXZeIAZBk
 UPBP3aTENTHIjLX8EO5TgxvpZESIoAv2mqdwp4iFOe5JCp91hWLhs/PoF8woRC5717XhBdezL
 2GDZQJaZmnk0746MQ0lSR5k0zBQCFzxIMYKxQiaURLISlQlGI4zPEXWozR8ZB4ViTAMo18r5/
 bJm2Wd6ty+jkMxx2CGWG0dc196V2QAC6NVnA66tw8zC9LqDcgXyJSttOXJtVHPZsNot0QHMo+
 xOLqoQlFBGp7PCQDfDJSduBNxEv4u2bOfWUaqbefe0dhj9I7eyfPTul/0XQWXYVLni3XHysvM
 Fx4/GYlAAOyXOdEWKMUwZ5WWKNG3I8+7qshiDSrF+GRwtEHQ15pWfaymZF9vmXqYblyt+0Fl1
 SICBs3BcCorWWqNOCRDDydry1jhYR8GgsYYm8v3VXeT2MNUbpRGRD7Z3ba5QT48Ty1SKUNYq0
 DKfxRKedUPAn8FN5aAVvssnHsXAkvIr/9n56beCLNlVUXqhf3LFNryEyChMIYo7L9wegCangZ
 JMdYY1d90tmj1A/1QfnS+owwOgOduGxuWJfRkigigEYKCz7fS6tDS2AVKTIuUDlkHLINl4Prq
 34glCQoTfsfWkVcCplO26zm2nf129DVP33jjvXIauNjBPaduzVLSVaPblj0spJtzkLWaat9x9
 oT9Xzca456XBCJ/uz2a3trPMHuwNgDCULjOuH/srXBpObU5Hncxr+/vOGtWJcNnvnCMfOPEWn
 CX8XNA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 18=2E Februar 2023 18:07:53 MEZ schrieb "Ar=C4=B1n=C3=A7 =C3=9CNAL" <ari=
nc=2Eunal@arinc9=2Ecom>:
>Hey there folks,
>
>The problem is this=2E Frank and I have got a Bananapi BPI-R2 with MT7623=
 SoC=2E The port5 of MT7530 switch is wired to gmac1 of the SoC=2E Port6 is=
 wired to gmac0=2E Since DSA sets the first CPU port it finds on the device=
tree, port5 becomes the CPU port for all DSA slaves=2E
>
>But we'd prefer port6 since it uses trgmii while port5 uses rgmii=2E Ther=
e are also some performance issues with the port5 - gmac1 link=2E
>
>Now we could change it manually on userspace if the DSA subdriver support=
ed changing the DSA master=2E
>
>I'd like to find a solution which would work for the cases of; the driver=
 not supporting changing the DSA master, or saving the effort of manually c=
hanging it on userspace=2E
>
>The solution that came to my mind:
>
>Introduce a DT property to designate a CPU port as the default CPU port=
=2E
>If this property exists on a CPU port, that port becomes the CPU port for=
 all DSA slaves=2E
>If it doesn't exist, fallback to the first-found-cpu-port method=2E

If adding such property i see it on switch level not port level so that it=
 can be defined only once to point to 1 port via phandle or index=2E

>Frank doesn't like this idea:
>
>> maybe define the default cpu in driver which gets picked up by core (de=
fine port6 as default if available)=2E
>> Imho additional dts-propperty is wrong approch=2E=2E=2Eit should be han=
dled by driver=2E But cpu-port-selection is currently done in dsa-core whic=
h makes it a bit difficult=2E

My first idea was putting port 5 below port 6 in dts so that port6 is the =
first cpu-port picked up by dsa core as default=2E

If the 5-below-6 way is not the right one i would prefer a driver solution=
, e=2Eg=2E let driver choose the best cpu based on fixed value (constant vi=
a define) or on highest throughput (trgmii > rgmii),but last may fail if bo=
th cpu-ports have same speed like mt7531=2E I have no idea how to set the c=
pu-port in mt7530 driver as it is set in dsa core=2E Should we override the=
 cpu-port set by core? I think no,maybe adding a callback which is used by =
core if defined else proceed as currently done=2E

These are the possible solutions i see atm=2E Maybe dsa people can share t=
heir opinion=2E

>What are your thoughts?
>
>Ar=C4=B1n=C3=A7

Hi

Just my thoughts about this=2E=2E=2E
regards Frank
