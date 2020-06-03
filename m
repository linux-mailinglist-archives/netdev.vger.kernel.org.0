Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4111ECBB5
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgFCInG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 04:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgFCInG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 04:43:06 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42726C05BD43
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 01:43:06 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d7so1349575ioq.5
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 01:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=gqwJomuBh7OM3abQd/8uUQAZ1haEzhtExZnsV2dw2NY=;
        b=asjV9sco/LFOSKPuqZY8D92vATsAdEHJR5RG3/Z38n50w+l7zn7FSbvaQ8vJ3Q0fEZ
         FpoH1qV2ue4bxMHYAH24qlKSzyME9G8FXyrIubinvNi1bU9VCH529hnR4L5mPm4aa9aQ
         O0RZ1m4GgfwW/Ip9ONOHd4a3MYhB53DU2hKDN2YVaOzu4YiaSQc7pWoc7KyNnkZcnIFq
         vni6w/svwfOLj1E2U2DhFrsxmrtHrYLmKAquwcXAE0WcnHf5hqs+klnfDXgqX0ssntEE
         /Q+ZMHckaj/o/LwI6fKqZv837wmNIFiBSejgXUmtjGdC4tMsCEuWfa4et7FWDc97G6Bm
         BdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=gqwJomuBh7OM3abQd/8uUQAZ1haEzhtExZnsV2dw2NY=;
        b=EsYBMXBB6G6FeQ0vwOSrGwIgMpOuR6QYx5lsLa1OUQNsdRQbatxCEoFFGP1Pi90vGm
         hOB9j/Or0GXY+F0HPElRLG17fLLb8qhFvyzrENGOUzgmAdb0Aec7U96FVStqW4IkJz9M
         1kylNfRBW3A6aFHlQVVbfgJI+JvdVjn11rkuypdhY53Ix62VAx+jD+OYk9le4OMZqvNS
         qYqaSomnF5jlMuqtSzCAg3v0fncK0hpqskvBQKCbXKIizdtE/wwtGC3Fu4DV8qWE7UoM
         EZiEAHzWy2/JF4ULw+NFc0AmGTBkp6ULS7TuzkHARQ4/AWRCUdW++52XCCVfKYyPShx7
         jokw==
X-Gm-Message-State: AOAM530WQ2DAz8q7J5+acBHV5W5mnGPVvKtaZTExzcQ6ogqNP1Emss39
        WfxKWtsGsCX3VqXJnGVwMsqwjesn6Mgdqz9xQkk=
X-Google-Smtp-Source: ABdhPJzh5ZUJZhTJiJADTDZuen/X6Ig7XcuIhGaonOAZl3z/otFqERbXviQppkf1udSCEVBnRwHu0pX8dYsA1RVnF6k=
X-Received: by 2002:a5d:9598:: with SMTP id a24mr2668967ioo.182.1591173785543;
 Wed, 03 Jun 2020 01:43:05 -0700 (PDT)
MIME-Version: 1.0
Reply-To: zaama250@gmx.us
Received: by 2002:a6b:7a07:0:0:0:0:0 with HTTP; Wed, 3 Jun 2020 01:43:04 -0700 (PDT)
From:   ZA ZA <ab9520487@gmail.com>
Date:   Wed, 3 Jun 2020 01:43:04 -0700
X-Google-Sender-Auth: 0bnrjRGwrD8_FamMjqmN_c_bdxA
Message-ID: <CAE+yXuRapWM8paKApvC+Q+m76Hu4Kk=DD-0CXhMRH320isFTEg@mail.gmail.com>
Subject: OK
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

An oil business man made a fixed deposit of =E2=82=AC15 million Euros in my
bank branch where I am a director and he died with his entire family
in a plane crash leaving behind no next of  in/Business Partner. I
propose to present you as next of kin/ Business Partner to claim the
fund, if interested contact me with your full name, and telephone
number to reach you and most importantly, a confirmation of acceptance
from you.


Ahmed Zama
