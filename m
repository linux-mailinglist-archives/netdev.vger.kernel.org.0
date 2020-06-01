Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F31E9B16
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 02:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgFAAyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 20:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbgFAAyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 20:54:43 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150E3C05BD43;
        Sun, 31 May 2020 17:54:42 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id c12so2941712lfc.10;
        Sun, 31 May 2020 17:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sxvplRRpCiypjqayPnDRE3Ho1Q+ee9Fp6Iu9/AnbZCA=;
        b=YDJHQgQn55qOOSQXBpUvYLixoq/R5BijAaZ/sotkAgQFoW2gajkBFcQseOV+lfkB9d
         7VMguE9IzL3VTY0tfNhQdQU/6swTnx1biu1s2oTXmJZkv9Z1QEMQOVEh7GmqplveK6Xx
         tz194CPz1Hqmbmqo6UbxEyLg32rau/mY293EmYSszqvhSNlTT+EWseMsbUoBP2JlcWoE
         4Fj9KbdHBsTgQeHK9ReGZqsrHyTlIlYDs3Qa6DcqnSFUzAmVYAdtv+DiCq+Sw5rEsk9W
         lOtFsTw3Fp+IKOaV8V4az125zumwZm1Lo6AVDCJUP6kp6rZUooQsLN3rOVwhohu6fGgI
         13Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sxvplRRpCiypjqayPnDRE3Ho1Q+ee9Fp6Iu9/AnbZCA=;
        b=CVJo67FoAxmYCiaWaTFHcB3NQJrxekIoBx56DlVLFOPN7EkyPtEqwcdjlrmPliXopd
         042p1lMJIQSzqll+8xFGWRfqU3OZZKmwOrKdM8zPwAbJDugba33uCAN20pZ+7tAVvaXF
         7rCMJtA72+OH3yu9JLcEbiuG14NQzhzflHMoYFRA0yHYXfpefqQXsUqfzcSrGbVWC/Y/
         4IMrfpPuh6kJxHdb8kN+SM7zq4MhDyouiv3pvYNbl2J3dn2/O7ZVFv0D1+SkBgxxA0qC
         ZSUoJ+iesb3pD5IbsPiGceWjYduJ+QfBnWf/UM3DB+dSjIpHfNhrIJ2ODJmN5DOnNLvu
         ty3Q==
X-Gm-Message-State: AOAM5339htzYr/PgV1iiDm9qwqSsRd2EAbkoqvLCSgISaqKqPbx6MQ1N
        Id94NG/DdA+Npa5n+8OCa02D9qQlcM7KcgKw7jXqJg==
X-Google-Smtp-Source: ABdhPJxdckX5AX2muywSyPhtC5V80TEwiPRDYrpTSoCpF/EMVmUhmV/sjyMBS2UWq5TzO8JXF9ezUGe9TFighDl5hRs=
X-Received: by 2002:ac2:53a6:: with SMTP id j6mr9949888lfh.73.1590972879071;
 Sun, 31 May 2020 17:54:39 -0700 (PDT)
MIME-Version: 1.0
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 31 May 2020 17:54:28 -0700
Message-ID: <CAADnVQJ7_gZk5osubErLwCsxbPEBHbLZQds=bJwLc07JxkVOVA@mail.gmail.com>
Subject: bpf-next is CLOSED
To:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

please fixes only for the next ~two weeks.
