Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD004ACB56
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 09:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfIHHac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 03:30:32 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:44127 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfIHHab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 03:30:31 -0400
Received: by mail-qk1-f173.google.com with SMTP id i78so9800244qke.11
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 00:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fl87ra6vQZ/LlDGltmcyzMiabuXSYY5YHTuiGKwkJho=;
        b=Gxzb3CJE7vZ88QbKpOofqnggWDV/GZbwOdBUGC7kxLiU6HkNdi7bt9VpI2rk7nuk/Y
         ql/4EuomF3DZmlyiWdZ0N43CHrp762/rbCXTqIitx7BbUceiuprD87IowTXzy/owH7Sm
         VA2Py87AkUYYcxwuAsb5TdF17dQpecsGtJlj7+EAG0MBJwMYWjsW0PvsvlKv2XptBZMY
         nfy6yj0lCsjeVFxE/VjbLQBAp3NZkHda3xQTezKSSyRRxE0hrTCcmWWZ/LfTxU5+ar6H
         MRw6mQwnpifZG3t+L1kQP6XJ48FXjadk6LqpddgIFmQPHQNUBynX10BgfQ7c5gsmcg3l
         RuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fl87ra6vQZ/LlDGltmcyzMiabuXSYY5YHTuiGKwkJho=;
        b=iYVGHCwLe0kUZSP+hqXgI6HpVnJu0iv1vQnbWRSpSThBilRV0o/TOAO8oqpQ2VFClA
         OfG+Wqd8cdaHjYcjYMF5ibv+8gd15rUhj9EIMvMcgVaL+s1sSeqNcsSUTWstfBpk/O/G
         7e4OWc2mn8FgK5pr45MLARJrVguWKMDFgJTmyW5Gqp/gzWvMGQhrHpC59mX5uHIs+UGU
         3SNgEy461jrtfiYRIW6gxbG97Y3FtKPWL24zdf1rYAqK0J3OPWI13hTKndQXhPpTqkUW
         rhETHM2T8z0ZHqNjQltDJNVK6s0y52XTsDh0+bdrjJIJtL14n4qTK2jJjcivSsIAEFvB
         6VAQ==
X-Gm-Message-State: APjAAAVVqRLPkZHCYwBxOhWqy97JoHkki4srdpuRzttzWyyc4Xvtxx6s
        Pm2klZ8MH8nl+VI+9rTZWrAMf4ykhbCsE5hsLbfCPJ38
X-Google-Smtp-Source: APXvYqzHYBshETbAY92W5HZOeKqeIed12LnT8Kv44CYKDql7PKp8Zdv1ba1w46tFcXjYlL+VNk1H0fPOobGn9cA3oCQ=
X-Received: by 2002:ae9:ec07:: with SMTP id h7mr17701670qkg.25.1567927830926;
 Sun, 08 Sep 2019 00:30:30 -0700 (PDT)
MIME-Version: 1.0
From:   Ranran <ranshalit@gmail.com>
Date:   Sun, 8 Sep 2019 10:30:51 +0300
Message-ID: <CAJ2oMhKUTUU0eHTmS62itBw6L9Jut=ps6y8GuVDP44xadn03dw@mail.gmail.com>
Subject: Q: fixed link
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

In documentation of fixed-link it is said:"
Some Ethernet MACs have a "fixed link", and are not connected to a
normal MDIO-managed PHY device. For those situations, a Device Tree
binding allows to describe a "fixed link".
"
Does it mean, that on using unmanaged switch ("no cpu" mode), it is
better be used with fixed-link ?

Thanks,
ranran
