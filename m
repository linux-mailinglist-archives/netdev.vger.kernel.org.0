Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C7061CAC
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbfGHKBw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 06:01:52 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35200 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728596AbfGHKBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 06:01:51 -0400
Received: by mail-ed1-f68.google.com with SMTP id w20so13999490edd.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 03:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8tQ5ypLBkhcFt2CRayk+Xv0ffeKwabb5TFqPnVPjNN0=;
        b=GoKg3JdCEFCANuD/8DtsX9LKj1dKGyTgFmsnqg4FdsIqPIWp8TY/U1evqlTnJUjWNx
         ayJKwTAs/zKbs4DRd+9ItZOYMMfGrdGBfwk/pV5720ku4heLesBrB9pYzSfsRkvGvOn0
         LeRnAtCXG6RiLpylcnHxOHpth+VB3nrmFtPeyt9u8Zc0H3HcHL6RRSFtEAsbX5XDeruU
         JkqvsN0b/aJjjytkgrVBdCyfWgwZbjzuVSx9ycJZDENLfT1mYSTrAJkb49vwN6y8JTha
         mlanognNRKsUctZLwnpgpiyV5RZWl8WKODeJVi2K7juJHvM/28qjUvZhexvdMkcteHsm
         yn8w==
X-Gm-Message-State: APjAAAVj7RmzEWTQQM2579cBKoAt+0XWrue9zyK2VL1t0ITm2xYTcjPd
        fS273rT5aY/2aKZAqKGzKQVcnA==
X-Google-Smtp-Source: APXvYqwwadQLy+Sx8hVRYrrBAzUHmFMp9YAEiI/eAZx67rYn4cmOabadTCepqJMxKetMEUM+EWBwqg==
X-Received: by 2002:a17:906:959:: with SMTP id j25mr15414218ejd.94.1562580110152;
        Mon, 08 Jul 2019 03:01:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id se3sm437293ejb.31.2019.07.08.03.01.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 03:01:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D2E5F181CE6; Mon,  8 Jul 2019 12:01:48 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>, michael.chan@broadcom.com
Cc:     gospo@broadcom.com, netdev@vger.kernel.org, hawk@kernel.org,
        ast@kernel.org
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add XDP_REDIRECT support.
In-Reply-To: <20190706.152646.270873493821496746.davem@davemloft.net>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com> <20190706.152646.270873493821496746.davem@davemloft.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Jul 2019 12:01:48 +0200
Message-ID: <87v9wczvxv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Michael Chan <michael.chan@broadcom.com>
> Date: Sat,  6 Jul 2019 03:36:14 -0400
>
>> This patch series adds XDP_REDIRECT support by Andy Gospodarek.
>
> I'll give Jesper et al. a chance to review this.

Couldn't find any issues other than what Ilias already pointed out. So,
assuming these get resolved, you can add my

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
