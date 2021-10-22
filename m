Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E42437A5C
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhJVPz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhJVPz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 11:55:57 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE37C061764;
        Fri, 22 Oct 2021 08:53:40 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id e10so8606526uab.3;
        Fri, 22 Oct 2021 08:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=o7tbFS9qrfqSlJTs8nJFhBp8hx7F/c4cT0wa5yen+WA=;
        b=UYyUDNmz2oq8WKKtGEB44bjHW7r4qFVp+HfV5MqQ6bW008fLhs/8SGoVgyoYDf1OSf
         JKd95p1OCwY1elMNoIrIE9tJvtEquaTSwa+VjNWgdBttuFOo13xddquv5b1NfkymgejH
         3f5iygTZQbsJT5gjz4t7Y49aWUA+rtNR2seXvrhhg0lSMuP9BWMFwLgDZRKMwRzqpjDV
         t0Ddq7GKvWaxEm6Dsi+cIBtsHfhZMKYep3Oz9h+zQy7t2YgLxorxTKKpjCUOWS2xZpQE
         9LznQkFOSaqY4H9EVVxISC9bdxe+mFShjubcl+zMHGod7UaEFNpf6ss6T9Fkw9NCgQVr
         F/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=o7tbFS9qrfqSlJTs8nJFhBp8hx7F/c4cT0wa5yen+WA=;
        b=63uWC9laW1HgRSu6yw1yz3IQjoMB9ZAMNpyAtZ3cvj+LiYIdrt/2vPwpwBeS7DQs5/
         rw6X7ZNMy6JD9aBGc6kQuOY52SjxRUoAQujM8Xck+zjrGI+6cVigTw9pbyTn9XqpKYQM
         fvOJoiaMuLHDwWRVtnkTQnqGJlv1jMO9NdplTPZSjSSpTrQj6vYaSCrUueJId+3NfVlD
         3BjYkPmSnxzBlx5cP+pz5tdMUv8bTmLz+wy+mPqgIRzoIrI+yrlcbhlvqqCUXLN2MQYb
         /ZmZM2JWXE2GvH3kIchE2O+Io8lXeRJExUbW5R0jq7DEr584nfDKUbEcykKQYs49fL+C
         gAfg==
X-Gm-Message-State: AOAM5327mFWXzENOMIPBacR7sP9EkbLyj16ysMBb5+ZgAH/0yJDy3h/J
        uogUXsVS8ky9PxlxeXp7ggliouWe7doiM2h7HbBRt2m2d3E=
X-Google-Smtp-Source: ABdhPJzk5OL0oMSoZb+L0++up544jUAsZWSYHmO8+4ftHvjMafms3ps/20awAUBZn6XpcoFIis/Rzuq0a+MaBzThhBI=
X-Received: by 2002:a67:f544:: with SMTP id z4mr348851vsn.19.1634918019064;
 Fri, 22 Oct 2021 08:53:39 -0700 (PDT)
MIME-Version: 1.0
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Fri, 22 Oct 2021 10:53:28 -0500
Message-ID: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
Subject: Unsubscription Incident
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

From Oct 11, I did not receive any emails from both linux-kernel and
netdev mailing list. Did anyone encounter the same issue? I subscribed
again and I can receive incoming emails now. However, I figured out
that anyone can unsubscribe your email without authentication. Maybe
it is just a one-time issue that someone accidentally unsubscribed my
email. But I would recommend that our admin can add one more
authentication step before unsubscription to make the process more
secure.

Thanks,
Lijun
