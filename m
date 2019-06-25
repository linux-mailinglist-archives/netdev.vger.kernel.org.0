Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE78055357
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732237AbfFYP1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:27:16 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:47016 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbfFYP1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:27:16 -0400
Received: by mail-pf1-f169.google.com with SMTP id 81so9642005pfy.13
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 08:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MuYqTRaqjc9uhuqdQWmY4GeLMus99M2VOVLjnJLIAE8=;
        b=ScvoKquBlpW5REp+b2xRdndihKjbeMrGqZzE9Ia20qtKfAvTXKLvGcbGrCyO6b3yHA
         NWlYrTmruCyy5PSuoZhyZgmBgFkTjh6mm7wyBhmFZb2Pi+wUZfLbFFarP3PMcG+qWsia
         F5o/2JsYdRzB13p8uFQHVf29sZJvUbfPHHD9Iby640DOALGnqxKbM+cHOwKOgUxOnA09
         vDz/hXizmsywQT9GaFhCC6ia7RsO6o04PJVVhIMkTylXNHJWSBJvTOWwR+s+mc1aWRZr
         9I8Db6jYukulKsw0EReymKsWqW58KfkeWsfJSBy9YyCipsDsJvwiRhd8Jueq0GPFZAVS
         HPlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MuYqTRaqjc9uhuqdQWmY4GeLMus99M2VOVLjnJLIAE8=;
        b=IdGxwpMaKLJx5kM7qdhnV+niSm4AtMieBCLj2qgyD4mPVMEStkZa+3buP+IVgCeGI5
         qbC6WK6QN1j16skjktJHeneo5onyeXhN5u3yXeXyr75kfm/7e4UX+uazGUK/PAv9U/1z
         dWGOiVepVEjRkcHacCnCqLktJ56q8BJsZ0rCjhR5BfoH4C/JEyxf/+ydA8aG62YX2Ku3
         38thRwHAQ6AIxJnBfLlTxgyYA7eciF0ai+nO6lgitHNxdghJgY7cKkWY/XR5kjiBn8HH
         DndcyT1gLKdYx0ZqMKZg/AmUZmhCsSRS2CiNuGJXuQWP6ah1hOuHlp/zc0brQ1hOjzTL
         DQFw==
X-Gm-Message-State: APjAAAXfBsw4iTR5t8I2OWwr754jUILlSuhhohiqic0z1eLXgIWqkWJb
        2Q93R92Nz4nAZz20r3nU65Y=
X-Google-Smtp-Source: APXvYqzKzSY1zFJFZ+aL3rRZiSivSTO6seMey3mjLxH6qBQ2cZb/pGk9Q9Oe62om5gTsKrkv4YzUCA==
X-Received: by 2002:a65:645a:: with SMTP id s26mr13400495pgv.70.1561476434970;
        Tue, 25 Jun 2019 08:27:14 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::3:20fe])
        by smtp.gmail.com with ESMTPSA id f10sm15627930pfd.151.2019.06.25.08.27.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 08:27:13 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 0/1] Fix broken build of mlx5
Date:   Tue, 25 Jun 2019 11:27:07 -0400
Message-Id: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

This fixes an obvious build error that could have been caught by
simply building the code before pushing out the patch.

Cheers,
Jes


Jes Sorensen (1):
  mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is disabled

 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.21.0

