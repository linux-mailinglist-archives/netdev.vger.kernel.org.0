Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E1143A073
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhJYTab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:30:31 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:44854 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234668AbhJYT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:29:21 -0400
X-Greylist: delayed 4636 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2021 15:29:21 EDT
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 024482E0DB0;
        Mon, 25 Oct 2021 22:26:56 +0300 (MSK)
Received: from 2a02:6b8:c12:2388:0:640:af0b:b98 (2a02:6b8:c12:2388:0:640:af0b:b98 [2a02:6b8:c12:2388:0:640:af0b:b98])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with HTTP id fQoSr70t9Cg1-QttmjFEs;
        Mon, 25 Oct 2021 22:26:55 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635190015; bh=ZtX0Ox2do1uGRIUvTp+jgzBCNguQfqwNP180tPcouig=;
        h=References:Date:Message-Id:Cc:Subject:In-Reply-To:To:From;
        b=nr2cIIxgUz7uO0o+jpZ2MXz/WBkqX9ZWkTxQLK1xauvJ7t+DIA3aaYjI6ropwcGAV
         WjLtCJyOSIujT4S8uckiOaZED9Ykz7CyYeL/hh0zXEfjAiuHMsPQDoJM7QXhdep7cJ
         C0+efy+gZ9AgdJDnB0QDZHd2ITQdGqogEuKH8C3o=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: by myt6-af0b0b987ed8.qloud-c.yandex.net with HTTP;
        Mon, 25 Oct 2021 22:26:55 +0300
From:   Alexander Azimov <mitradir@yandex-team.ru>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     zeil@yandex-team.ru, Lawrence Brakmo <brakmo@fb.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
In-Reply-To: <b8700d59-d533-71ee-f8c3-b7f0906debc5@gmail.com>
References: <20211025121253.8643-1-hmukos@yandex-team.ru> <b8700d59-d533-71ee-f8c3-b7f0906debc5@gmail.com>
Subject: Re:[PATCH] tcp: Use BPF timeout setting for SYN ACK RTO
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Mon, 25 Oct 2021 22:26:55 +0300
Message-Id: <6178131635190015@myt6-af0b0b987ed8.qloud-c.yandex.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,
 
Can you please clarify why do you think that SYN RTO should be accessible through BPF and SYN ACK RTO should be bound to TCP_TIMEOUT_INIT constant?
I can't see the reason for such asymmetry, please advise.
 
I also wonder what kind of existing BPF programs can suffer from these changes. Please give us your insights.

ps: this is a copy of the original message, hope this one will come in a plain text
