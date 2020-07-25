Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F6122D71B
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 13:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgGYLnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 07:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgGYLnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 07:43:33 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3851C0619D3
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 04:43:32 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l4so12451978ejd.13
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 04:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=SGMkATQ0BzQCqgOcGG7Dgfh7CB1yD8Nfkag1D9wyXY4=;
        b=Dzg4SiA2xE38tcZ2rkLAr8eDRq6vqYxedqgk304DbE+/SO16SCW8y6wRANUnDGv4xK
         ujnNyroHj34GOtUbYY/6WPKUKVW64qIWH4kkz5BbYhXTpI6XwJMItA4/tiI5d7TZLk0J
         oUh0Q6IeI5r0krHsrud74h5ygH+IN4ArZn7tygADLSesNNEghozq5iWnQTr566u8HpuB
         SBa/8VhXLxsWWuTSez538moOcwwHQvqYQ/xTV3CAaJEoELBStlnk76MpYgJbpPKSb4Wf
         qrHU9GrsfmgLDkQlEW58dhsZh1lLztH3snQkN5o19/0QOzkkt+k36zmYjm168UpQ6hIZ
         r+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=SGMkATQ0BzQCqgOcGG7Dgfh7CB1yD8Nfkag1D9wyXY4=;
        b=A9bw4/v7fLW5zCjPy8IjysO1PM0jPK/QqmNk0IBDnNd8K4DbiA/6c2Mt1I8M0zs461
         9f5bjE6iXTjUoAa0KETebZvBcH6kWWfIDyuj8KoeBWr+98jzeB8X9mkZDCdkPy7bvjP9
         d4uH1Pchp+9/VbLT9Nn/tdSzKfSkRk+dLDTP4rwMVSX5GHB0fEHKkQZPq2YxyoKqi/gn
         lc7GMJYshmSK6IMyK4MlAKrvhqEEt2w+qtaxx5T929r/ZxEOzHu0vnz4FtulYhNEVznE
         7+coEAJgBD+E5RINpG2VlhZlN1jz1CHM+VTz8b4/jWbD9hjVf/RXbvg0Jw60l9OQkFgC
         JWWg==
X-Gm-Message-State: AOAM530Yej5WWwrJzwN6i8A9l0AP7P/CtIDSu8THJyuhgHYzUQtOdDkG
        q9kC6S6NRGjVYmee7N0k1Zk=
X-Google-Smtp-Source: ABdhPJzlcdjdywZh7ISF6Z6N7XgI+zuwdfTjgQGmbwY0mdgVWz0bIylogIha2FCVaSBYoc0rXm2TlQ==
X-Received: by 2002:a17:906:1756:: with SMTP id d22mr13191999eje.29.1595677410315;
        Sat, 25 Jul 2020 04:43:30 -0700 (PDT)
Received: from manjaro.localdomain ([37.237.100.18])
        by smtp.gmail.com with ESMTPSA id w19sm2647997ejv.92.2020.07.25.04.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 04:43:29 -0700 (PDT)
Received: by manjaro.localdomain (Postfix, from userid 1000)
        id 9D0378521B; Sat, 25 Jul 2020 14:43:27 +0300 (+03)
Date:   Sat, 25 Jul 2020 14:43:27 +0300
From:   Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
Subject: ethtool 5.7: --change commands fail
Message-ID: <20200725114327.GC125759@manjaro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool: v5.7
kernel: v5.4.52
driver: r8169 + libphy

Starting from v5.7, all ethtool --change commands fail to apply and
show the following error message:

$ ethtool -s ens5 autoneg off
netlink error: No such file or directory
Cannot set new settings: No such file or directory
  not setting autoneg

'git bisect' points to:
8bb9a04 (ethtool.c: Report transceiver correctly)

After debugging I found that this commit sets deprecated.transceiver
and then do_ioctl_slinksettings() checks for it and returns -1.
errno is thus invalid and the the error message is bogus.

With debugging enabled:

$ ethtool --debug 0xffff -s ens5 autoneg off
sending genetlink packet (32 bytes):
    msg length 32 genl-ctrl
    CTRL_CMD_GETFAMILY
        CTRL_ATTR_FAMILY_NAME = "ethtool"
<message dump/>
received genetlink packet (52 bytes):
    msg length 52 error errno=-2
<message dump/>
netlink error: No such file or directory
offending message:
    ETHTOOL_MSG_LINKINFO_SET
        ETHTOOL_A_LINKINFO_PORT = 101
Cannot set new settings: No such file or directory
  not setting autoneg
