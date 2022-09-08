Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78E35B2994
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiIHWs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIHWsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:48:53 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3C05F4C
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 15:48:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k9so28770623wri.0
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 15:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timebeat-app.20210112.gappssmtp.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=QhJ+ciZR8l05l/hNFtYzk5ZBCcHPhOoWqQqHaLzDj+0=;
        b=EdB61Xy4MfkkBiy5yiuH/biXyRVOtn2s9aAnooVFIQazvH8pXFBc6C5HZ7emtoJfzX
         Jkt3ElBOHdWLNBfjBGfQirvPaXbEmKz+FTOln5V4+YorzPnLQ4f/Np5MHaNYcQC6k7BD
         PwGmkw5NLfML6S/DE8pP1hgjrKS/F2wv4pa6T695aw+RRRKEEVdioslxYeFGbE1BCc9S
         RjXBXZa0oE0A8EggU0TR/wgMZm3jXzqXDXNi0aFtRxmR7ZoIPzMzZzbJi9ze49GkQEo9
         p++0VkkzQLbFPYL2pTgBo7qgngSmc3ht5KZolZwgpLmvUDJgNg9K06pe2/Iut8gklyM+
         B5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=QhJ+ciZR8l05l/hNFtYzk5ZBCcHPhOoWqQqHaLzDj+0=;
        b=pknb0fRzgXfhKLa4YamLTTcXNWx5IszmvwMp+q+HEAtKn7lnIhF3PvnAzHRuwLCHIr
         RUv2DSQOe//B30YORslDk/O/JFFaUPv4ufaSc2ypg3q7AJf5fdygPTeFO0YtqZcyCrMo
         wX5PtefOVfeipJGofbEHWq6ibMrLbaSdbyev2LHdok3BoLUondYnnkGeujsBcAB2648D
         HP0u87OEVHiyhCIk5Th40Uk0XTCe8thNh+y4V09eOHxU1E6v8o2tC/qVCRl5uR4O2fhQ
         cGghKJ3+iZDdAOGJwLPozxuOoL6ov2eC6EywftzBPezQPm8RwJby0x+BGTDu/nmrZ4Xz
         vZmA==
X-Gm-Message-State: ACgBeo1JeaXf107ug9n0DGZFewtST5uPMEHvzqmFfpPoboweM/gS+Dk8
        8Khc07n6AVM8dYJJ0bca1pJRYg==
X-Google-Smtp-Source: AA6agR56S2z+SNI5kz0cij/wk15mBghGXTaz1JPyQsKaeSaZ1hxD/CizD84dw/5KR+bpWTghJoDA8Q==
X-Received: by 2002:a05:6000:16ce:b0:228:62e0:37a6 with SMTP id h14-20020a05600016ce00b0022862e037a6mr6324079wrf.563.1662677330408;
        Thu, 08 Sep 2022 15:48:50 -0700 (PDT)
Received: from smtpclient.apple ([2a02:6b61:b014:9045:9d1b:aad0:1a2a:2fe6])
        by smtp.gmail.com with ESMTPSA id d16-20020adffd90000000b002205a5de337sm301841wrr.102.2022.09.08.15.48.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Sep 2022 15:48:49 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next 1/1] igc: ptp: Add 1-step functionality to igc
 driver
From:   Lasse Johnsen <lasse@timebeat.app>
In-Reply-To: <YxpsejCwi8SfoNIC@hoboy.vegasvil.org>
Date:   Thu, 8 Sep 2022 23:48:48 +0100
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Jonathan Lemon <bsd@fb.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C4B215C0-52DA-4400-A6B0-D7736141ED37@timebeat.app>
References: <44B51F36-B54D-47EB-8CDD-9A63432E9B80@timebeat.app>
 <YxpsejCwi8SfoNIC@hoboy.vegasvil.org>
To:     Richard Cochran <richardcochran@gmail.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

PTP over UDPv4 can run as 2-step concurrently with PTP over Ethernet as =
1-step.

Below tshark output from Timebeat in the lab.

All the best,

Lasse
---
[root@gm03 ~]#  tshark -i ens1 ether proto 0x88F7 or port 319 or port =
320
Running as user "root" and group "root". This could be dangerous.
Capturing on 'ens1'
 ** (tshark:501799) 23:40:12.801240 [Main MESSAGE] -- Capture started.
 ** (tshark:501799) 23:40:12.803786 [Main MESSAGE] -- File: =
"/var/tmp/wireshark_ens1zTZBYi.pcapng"
    1 0.000000000 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Sync Message
    2 0.000174188 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 Sync =
Message
    3 0.029971841 HewlettP_1c:42:03 =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Delay_Req Message
    4 0.030112739 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 68 =
Delay_Resp Message
    5 0.999391207 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 Sync =
Message
    6 0.999420338 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 106 =
Announce Message
    7 0.999469318 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Sync Message
    8 0.999493068 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 78 =
Announce Message
    9 0.999519838 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 =
Follow_Up Message
   10 1.008318061 HewlettP_1c:42:03 =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Delay_Req Message
   11 1.008417187 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 68 =
Delay_Resp Message
   12 1.999732615 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 Sync =
Message
   13 1.999774247 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Sync Message
   14 1.999840628 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 =
Follow_Up Message
   15 2.008590292 HewlettP_1c:42:03 =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Delay_Req Message
   16 2.008662394 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 68 =
Delay_Resp Message
   17 3.000152149 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 Sync =
Message
   18 3.000183805 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 106 =
Announce Message
   19 3.000195810 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Sync Message
   20 3.000216212 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 78 =
Announce Message
   21 3.000288899 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 =
Follow_Up Message
   22 3.009000057 HewlettP_1c:42:03 =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Delay_Req Message
   23 3.009075505 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 68 =
Delay_Resp Message
   24 4.000147951 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 Sync =
Message
   25 4.000181728 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Sync Message
   26 4.000248327 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 =
Follow_Up Message
   27 4.008972302 HewlettP_1c:42:03 =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Delay_Req Message
   28 4.009030511 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 68 =
Delay_Resp Message
   29 4.999682198 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 Sync =
Message
   30 4.999742635 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Sync Message
   31 4.999747433 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 106 =
Announce Message
   32 4.999772787 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 78 =
Announce Message
   33 4.999857708 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 =
Follow_Up Message
   34 5.008507739 HewlettP_1c:42:03 =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Delay_Req Message
   35 5.008628544 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 68 =
Delay_Resp Message
^C   36 5.999954160 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 Sync =
Message
   37 5.999995843 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Sync Message
   38 6.000067764 10.101.101.33 =E2=86=92 224.0.1.129  PTPv2 86 =
Follow_Up Message
   39 6.008777977 HewlettP_1c:42:03 =E2=86=92 IEEEI&MS_00:00:00 PTPv2 60 =
Delay_Req Message
   40 6.008864087 IntelCor_91:5e:9d =E2=86=92 IEEEI&MS_00:00:00 PTPv2 68 =
Delay_Resp Message
40 packets captured=20

> On 8 Sep 2022, at 23:28, Richard Cochran <richardcochran@gmail.com> =
wrote:
>=20
> On Thu, Sep 08, 2022 at 11:18:35PM +0100, Lasse Johnsen wrote:
>> This patch adds 1-step functionality to the igc driver
>> 1-step is only supported in L2 PTP
>> (... as the hardware can update the FCS, but not the UDP checksum on =
the fly..)
>=20
> What happens when user space dials one-step, but in a UDPv4 PTP =
network?
>=20
> Thanks,
> Richard

