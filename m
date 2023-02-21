Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DC469E303
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbjBUPEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbjBUPEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:04:35 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECE410CE
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:04:31 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id iv11-20020a05600c548b00b003dc52fed235so3254759wmb.1
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8LOt52TnL7qqgco82gkhCrGUU8Aq366sJzQBpSTHzLs=;
        b=m9WR50bLNBUgeml2Y1CL6RnxQoq+Jw75Vx1svcOjyLMD3pkLACWKYu7m485rdm2H85
         QDw0HoPcv412QEgB5nO4n4Z0WeMUYnldQNJ1h47ZMVw+d5fOB6qsF5pniL8BaqkahRKk
         GA6i+HhHmhqypNhBpyVtuUCorDvw9kcPoOV3Liha0jKL0X1ygnhAX+kbO5eV+4VQOoL9
         1S6LqU7VrcKIktc2HN9yI2I9OMjGiPJC/NigoOmxr532y92kDMqLOh9NbPhN7ITLUrV9
         AgW0/DqxbnhjOPphY+yKe6W4CtASbUxw0dBHzkCbynUT6Mq4ghfjL2jeYPmd+OqXNpDQ
         N+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8LOt52TnL7qqgco82gkhCrGUU8Aq366sJzQBpSTHzLs=;
        b=U6u/0T2vYC+t5A8pBPdZidmU+5t1cFkox3xDzVouY6ecB+0rg/qaG78VLJi0aSvWYk
         QX5qe72NVCn5ImgfKSpMtsYbrUuXEqZ9CScWgw1uIyVNW0lhWWGjYUJfJOGorf/5559W
         IBZ+m2Yl3/+U9xxi2YuvIG6DrTam4/9JPrKfiaXlGKsOzt+6Dt2hzlJuUtel7PjQSBkq
         RCBkHzhtGbcBRwcWiexhpxlRNEYTNoz0urSAVUqHS/w0pRem+FI4rjEcu+UScXWr7J8L
         cNFKi1hYCFWwT8cLzT6NgJlthilp7cR2MncFYAbHlg6nPBX9KXd/1J9GCKCdebGHR8yf
         IcHQ==
X-Gm-Message-State: AO0yUKVpR0CNuQviPmBtTel+P9VsdsJnskckUVOp1bNQ8svtridpsvt2
        iUGyKiuAB5O3pd/iGSgWb/9vtIOUsBs=
X-Google-Smtp-Source: AK7set94gneFq4fBXqgSMb8BBJCr84GdpR7GopS8CVqEv96/n2R7BFXyySfqZezaMfyfOx6JoD08yA==
X-Received: by 2002:a7b:ce96:0:b0:3da:2a78:d7a4 with SMTP id q22-20020a7bce96000000b003da2a78d7a4mr3934465wmj.21.1676991869432;
        Tue, 21 Feb 2023 07:04:29 -0800 (PST)
Received: from DESKTOP-L1U6HLH ([39.42.138.70])
        by smtp.gmail.com with ESMTPSA id i21-20020a1c5415000000b003e208cec49bsm5283052wmb.3.2023.02.21.07.04.28
        for <netdev@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 21 Feb 2023 07:04:28 -0800 (PST)
Message-ID: <63f4dd7c.1c0a0220.db75c.ea6c@mx.google.com>
Date:   Tue, 21 Feb 2023 07:04:28 -0800 (PST)
X-Google-Original-Date: 21 Feb 2023 10:04:29 -0500
MIME-Version: 1.0
From:   trinidad.dreamlandestimation@gmail.com
To:     netdev@vger.kernel.org
Subject: Building Estimates
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0D=0A=0D=0AIn case you really want take-offs for a developmen=
t project, we ought to be your consultancy of decision. Reach out=
 to us assuming that you have any undertakings for departure whic=
h could utilize our administrations.=0D=0A=0D=0ASend over the pla=
ns and notice the exact extent of work you need us to assess.=0D=0A=
We will hit you up with a statement on our administration charges=
 and turnaround time.=0D=0AIn case you endorse that individual st=
atement then we will continue further with the gauge.=0D=0A=0D=0A=
For a superior comprehension of our work, go ahead and ask us que=
stions .=0D=0A=0D=0AKind Regards=0D=0ATrinidad Comstock	=0D=0ADre=
amland Estimation, LLC

