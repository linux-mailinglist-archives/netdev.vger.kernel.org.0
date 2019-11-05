Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5926CF08B1
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfKEVuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:50:22 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51810 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfKEVuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:50:22 -0500
Received: by mail-wm1-f67.google.com with SMTP id q70so1068158wme.1
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yx7LyivW0XkMI4d7AQIktAQMCVAOLAVQ5fze3jgZqs8=;
        b=OzX2pnyL6vprjmtjKpHBbWxJ9FNK0tx6TIMbhtQQzeyNLyKnDzji9z8lJgMinkodw3
         yxdR7AnLvZtrScmcf8gr68tz6rfkx8XQP3GQFd2YDCENI8UMNcBEUm8uK1jeNKIR08/I
         a7CkvuYvh1qRjfOFWmXJY9O/SiVu8Ec9WBP7wLVzkagYgZ8t/9N8pQ2L9HLQdu44WkIf
         gRt8kQb645zQgKcxtrUAmWXWGQIwMuN7osnE4PhUvYLzYs3wpQk13c60LeanFyHISgb5
         +YcJgG8P0SudAGB12wHn/RHJaYGQzOBzUJAd/+mWa89BP3TGlPJZMAuQexHgKIL7dl7L
         hIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yx7LyivW0XkMI4d7AQIktAQMCVAOLAVQ5fze3jgZqs8=;
        b=rn4NlnpP7O3TF/safitODPgtcJRz7Efyf9DfuDG7Xvt2vkg5ZYfmLTS9C3MNkEFn6V
         YqwCR09l1Ypl4/VD1DE/Wnch6mnvm1N8J2Qjfo0HFfeeDw716B8+uFbtQyXQw+PilknI
         rpUqNILte+aFO9+0lN2WV5KlMOmJpVEIJZo1gK+wsllsaXUMZV7zD9j3XP8JyBEFKFGQ
         fJSr0gdeDUttEbX2ayX+MOF6Xn0XuOeYhsv/fqhayWexpq+GtJd0mIb40prdrw/cHGY7
         5fdU6z6j3E0Aq9LiCixJEBA/mWQKOkL/lA1n9s7+YdNQfC0VK19/JUw9jiC5UU6Zgchs
         iSmA==
X-Gm-Message-State: APjAAAXVupVQ/SM1aE3PCP7m+H2GGGJwCjhcBtuC77ixiU8+/crOpx15
        2ob8EFI2lzu/LhoZCMagBPo=
X-Google-Smtp-Source: APXvYqwYTm//vVE1EEjSdTrMj/xXWx4fx7PhGFiNE5WM4dTP5ZEUqJMlu2ByeUgNqBbTlnu7ner8cw==
X-Received: by 2002:a7b:c934:: with SMTP id h20mr332870wml.89.1572990620322;
        Tue, 05 Nov 2019 13:50:20 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id r19sm25389732wrr.47.2019.11.05.13.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 13:50:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/2] Bonding fixes for Ocelot switch
Date:   Tue,  5 Nov 2019 23:50:12 +0200
Message-Id: <20191105215014.12492-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes 2 issues with bonding in a system that integrates the
ocelot driver, but the ports that are bonded do not actually belong to
ocelot.

Claudiu Manoil (2):
  net: mscc: ocelot: don't handle netdev events for other netdevs
  net: mscc: ocelot: fix NULL pointer on LAG slave removal

 drivers/net/ethernet/mscc/ocelot.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.17.1

