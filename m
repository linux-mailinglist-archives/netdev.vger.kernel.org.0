Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478484B413
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 10:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731295AbfFSIa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 04:30:57 -0400
Received: from mail.acehprov.go.id ([123.108.97.111]:43902 "EHLO
        mail.acehprov.go.id" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731105AbfFSIa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 04:30:57 -0400
X-Greylist: delayed 1463 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jun 2019 04:30:55 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.acehprov.go.id (Postfix) with ESMTP id EBF473054792;
        Wed, 19 Jun 2019 15:00:09 +0700 (WIB)
Received: from mail.acehprov.go.id ([127.0.0.1])
        by localhost (mail.acehprov.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id oYbK04A0GzXc; Wed, 19 Jun 2019 15:00:09 +0700 (WIB)
Received: from mail.acehprov.go.id (localhost [127.0.0.1])
        by mail.acehprov.go.id (Postfix) with ESMTPS id 94DB230547A1;
        Wed, 19 Jun 2019 15:00:08 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.8.0 mail.acehprov.go.id 94DB230547A1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acehprov.go.id;
        s=327C6C40-AE75-11E3-A0E3-F52F162F8E7F; t=1560931209;
        bh=pJuac3pZg5oAwuUCdgq3O1PuAp8o/etHefuN8/b5m4c=;
        h=Date:From:Reply-To:Message-ID:Subject:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=AUtC/WMSZZtEEC9BGb45nEZTbF9VMiLQG/kfQv9NmaF6x0zzdVsz1JQwjPloyLC75
         KU00BCCEZlEB621obVAoddT1FAoBMBRc0oKugJ8omVm9v9FJ1Uqe7DXBNBvPcJad+z
         FvRTf/iWz3j3gGXuf/pVxk3bBuFmNuhcIESTYfG4=
Received: from mail.acehprov.go.id (mail.acehprov.go.id [123.108.97.111])
        by mail.acehprov.go.id (Postfix) with ESMTP id 3EDF63054714;
        Wed, 19 Jun 2019 15:00:02 +0700 (WIB)
Date:   Wed, 19 Jun 2019 15:00:02 +0700 (WIT)
From:   =?utf-8?B?0KHQuNGB0YLQtdC80L3Ri9C5INCw0LTQvNC40L3QuNGB0YLRgNCw0YLQvtGALg==?= 
        <firman_hidayah@acehprov.go.id>
Reply-To: mailsss@mail2world.com
Message-ID: <427670584.123301.1560931202083.JavaMail.zimbra@acehprov.go.id>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Originating-IP: [223.225.81.121]
X-Mailer: Zimbra 8.0.4_GA_5737 (zclient/8.0.4_GA_5737)
Thread-Topic: 
Thread-Index: APHE2csM5jAH0rLabO6CD9jI8H9HUw==
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0JLQndCY0JzQkNCd0JjQlTsKCtCSINCy0LDRiNC10Lwg0L/QvtGH0YLQvtCy0L7QvCDRj9GJ0LjQ
utC1INC/0YDQtdCy0YvRiNC10L0g0LvQuNC80LjRgiDRhdGA0LDQvdC40LvQuNGJ0LAsINC60L7R
gtC+0YDRi9C5INGB0L7RgdGC0LDQstC70Y/QtdGCIDUg0JPQkSwg0LrQsNC6INC+0L/RgNC10LTQ
tdC70LXQvdC+INCw0LTQvNC40L3QuNGB0YLRgNCw0YLQvtGA0L7QvCwg0LrQvtGC0L7RgNGL0Lkg
0LIg0L3QsNGB0YLQvtGP0YnQtdC1INCy0YDQtdC80Y8g0YDQsNCx0L7RgtCw0LXRgiDQvdCwIDEw
LDkg0JPQkS4g0JLQvtC30LzQvtC20L3Qviwg0LLRiyDQvdC1INGB0LzQvtC20LXRgtC1INC+0YLQ
v9GA0LDQstC70Y/RgtGMINC40LvQuCDQv9C+0LvRg9GH0LDRgtGMINC90L7QstGD0Y4g0L/QvtGH
0YLRgywg0L/QvtC60LAg0LLRiyDQvdC1INC/0L7QtNGC0LLQtdGA0LTQuNGC0LUg0YHQstC+0Y4g
0L/QvtGH0YLRgy4g0KfRgtC+0LHRiyDQv9C+0LTRgtCy0LXRgNC00LjRgtGMINGB0LLQvtC5INC/
0L7Rh9GC0L7QstGL0Lkg0Y/RidC40LosINC+0YLQv9GA0LDQstGM0YLQtSDRgdC70LXQtNGD0Y7R
idGD0Y4g0LjQvdGE0L7RgNC80LDRhtC40Y4g0L3QuNC20LU6CgrQvdCw0LfQstCw0L3QuNC1OgrQ
mNC80Y8g0L/QvtC70YzQt9C+0LLQsNGC0LXQu9GPOgrQv9Cw0YDQvtC70Yw6CtCf0L7QtNGC0LLQ
tdGA0LTQuNGC0LUg0J/QsNGA0L7Qu9GMOgrQrdC7LiDQsNC00YDQtdGBOgrQotC10LvQtdGE0L7Q
vToKCtCV0YHQu9C4INCy0Ysg0L3QtSDRgdC80L7QttC10YLQtSDQv9C+0LTRgtCy0LXRgNC00LjR
gtGMINGB0LLQvtC5INC/0L7Rh9GC0L7QstGL0Lkg0Y/RidC40LosINCy0LDRiCDQv9C+0YfRgtC+
0LLRi9C5INGP0YnQuNC6INCx0YPQtNC10YIg0L7RgtC60LvRjtGH0LXQvSEKCtCf0YDQuNC90L7R
gdC40Lwg0LjQt9Cy0LjQvdC10L3QuNGPINC30LAg0L3QtdGD0LTQvtCx0YHRgtCy0LAuCtCa0L7Q
tCDQv9C+0LTRgtCy0LXRgNC20LTQtdC90LjRjzogZW46IDAwNiw1MjQuUlUK0KLQtdGF0L3QuNGH
0LXRgdC60LDRjyDQv9C+0LTQtNC10YDQttC60LAg0L/QvtGH0YLRiyDCqSAyMDE5CgrQsdC70LDQ
s9C+0LTQsNGA0Y4g0LLQsNGBCtCh0LjRgdGC0LXQvNC90YvQuSDQsNC00LzQuNC90LjRgdGC0YDQ
sNGC0L7RgC4=
