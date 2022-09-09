Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EA55B323E
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 10:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiIIIva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 04:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiIIIv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 04:51:28 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5917412D1A3
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 01:51:26 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b17so1593987wrq.3
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 01:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timebeat-app.20210112.gappssmtp.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=o4v6uYfzoD6KnQrl4PxPjL6EwrOq/CvYCb/SFc+M9hk=;
        b=4qsgMxGQBzxi8xRAeJSp1NOZdrIJNFFgwvcH8DasvJ5ov0bHHSUInalrR5B7x6W7Sd
         N2cWAun+FBsTxEtaYVqXzyyNJbTWc5xYCtXbQsy61ym3dhhKL1v616NizG3PhPZZA6SW
         +BDvLEQQf8VnWzil37jZCGATImNYbWaw/lvLbO21GqyeO4XMn986GHXDhp7yA/6Y8b84
         u4ouF5Sr6XD8f981mbDg1UvKzw1ijbp62mWjb3q1cUV4/JFucTMERJ9zXIIdcBxBfyU4
         K95oLpcHsj4lSm2hr4RTv9rK3l+xXynDRzavBIt4sbx+hqusxw9xbwNsbBruvi5OIeFM
         RnvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=o4v6uYfzoD6KnQrl4PxPjL6EwrOq/CvYCb/SFc+M9hk=;
        b=FUXT+hb56GDq9+TP3r2s/ysldypda+nkH9Qwc1fqhq4mT2q30eilj9jql5D2IfhL3O
         c5mWYEUGV92nuueIgqWoeJqJ+D2Po1Arlx0pR2JOJc8nrIJJTAMaQE3665Y0eZd66Xbr
         /0dH8tgbZP12Y2soYWe44wq66rLxB7bqHsw7IvJSyl/GmZNwTHlfSTYZmyHnA+Zoo70Y
         /v8mYkUafiABPmRsSBADOLubbOjXNvfzFt7Nu0qoOYLawdMSEsMtU9ml2MXqEOAKxhws
         ESkERH2holJZYhXgJGcOHzl+De9tzS1UNugSgB94nenMsW7U38eQGvOlgyro41HME4ZR
         pKTw==
X-Gm-Message-State: ACgBeo079QrZtK4+wuM/o0EITPLgwrFqbZYMvuWJ4SinckrFZbjKhPiF
        7t4vwAbnrLnkOKkW0kvHU9p46VMAhxKDbQ==
X-Google-Smtp-Source: AA6agR7d9sZM83CRdd8a8NazT1kbJRBWId218y5wEBAaZAHG+9ZJCxf+b6B8Qi/k3L3ao26TR8ud1A==
X-Received: by 2002:a05:6000:136b:b0:22a:3b92:4c05 with SMTP id q11-20020a056000136b00b0022a3b924c05mr1497171wrz.183.1662713484684;
        Fri, 09 Sep 2022 01:51:24 -0700 (PDT)
Received: from smtpclient.apple ([2a02:6b61:b014:9045:9d1b:aad0:1a2a:2fe6])
        by smtp.gmail.com with ESMTPSA id n16-20020adfe790000000b002237fd66585sm1287410wrm.92.2022.09.09.01.51.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Sep 2022 01:51:24 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next 1/1] igc: ptp: Add 1-step functionality to igc
 driver
From:   Lasse Johnsen <lasse@timebeat.app>
In-Reply-To: <YxqqQDnNUITPLvlg@hoboy.vegasvil.org>
Date:   Fri, 9 Sep 2022 09:51:23 +0100
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Jonathan Lemon <bsd@fb.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D9C2C300-C517-4904-ACDA-80681766F3E4@timebeat.app>
References: <44B51F36-B54D-47EB-8CDD-9A63432E9B80@timebeat.app>
 <YxpsejCwi8SfoNIC@hoboy.vegasvil.org>
 <C4B215C0-52DA-4400-A6B0-D7736141ED37@timebeat.app>
 <YxqqQDnNUITPLvlg@hoboy.vegasvil.org>
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

My apologies, I will try and be more specific.

This patch affects only skbs in the TX direction which upon being passed =
to ptp_classify_raw are found=20
to be of class PTP_CLASS_L2 and of class PTP_CLASS_V2, and on being =
passed to ptp_msg_is_sync
are found to be of type SYNC as well.

So where the driver received an ioctl with tx config option =
HWTSTAMP_TX_ONESTEP_SYNC it will process=20
skbs not matching the above criteria (including  PTP_CLASS_IPV4) as it =
would have had the tx config option=20
been HWTSTAMP_TX_ON. This patch does not change the behaviour of the =
latter in any way.

Therefore a user space application which has used the =
HWTSTAMP_TX_ONESTEP_SYNC tx config option
and is sending UDP messages will as usual receive those messages back in =
the error queue with=20
hardware timestamps in the normal fashion. (provided of course in the =
case of this specific driver that
another tx timestamping operation is not in progress.)

All the best,

Lasse

> On 9 Sep 2022, at 03:51, Richard Cochran <richardcochran@gmail.com> =
wrote:
>=20
> On Thu, Sep 08, 2022 at 11:48:48PM +0100, Lasse Johnsen wrote:
>> PTP over UDPv4 can run as 2-step concurrently with PTP over Ethernet =
as 1-step.
>=20
> That is not my question.
>=20
> What happens when user space dials one-step and UDP?
>=20
> Thanks,
> Richard

