Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31443EA727
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238367AbhHLPIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237871AbhHLPIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:08:47 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8543DC061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:08:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e15so7673098plh.8
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rGeykpsu830yZUbnJ/L/xYSxR34+JJQ6kc/iu0wkuuc=;
        b=C2gzilL6GCzdhjPlPJbcpF3Zx2n3Tn8HLWnIAt+7hWQk49lb202mhkCr6kKCwmScNs
         w6KKQik6m+tMLQnaokm5/5vO7sSUYxufbW2vXI2bQN+ckDQhMBwc03DqQYNGV0n8m7mM
         76/wKvPIMOeQUenBdOtUxTdu8EXnmWsGHNnyZ9k/ImjkSzCikVVHe8SaHNDIVk7Ljiin
         5VgQ04P7JAek93+agjO1XLCkDRIZh9e0yCcthIXPJgn7AGfyb9Wi/jB92Ft25dCZhvDW
         4gT2GoupYKaxDrXGQAM/+64IrPJXxCVdHxy0AH/cFFtw4KHgxwITHiebN3Ay7R+L3+qo
         vXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rGeykpsu830yZUbnJ/L/xYSxR34+JJQ6kc/iu0wkuuc=;
        b=KgABoMtl7oGV6jjuzlH+8hSILYrZ9cRxRy4mW30rdbbyR1dYeDsL2ITfDUZd/Grmu8
         RfFMJ7tYRZ1e1l/QghHUm6AM7j0pLU5zF/0CFWhSYqZcot8Mgl1MvlHCrVZh5gkS5/08
         eYdMgRd2ZThc+mHbzKyNPGTiZzqBZb3sFKr2xIrWMx808yeuHd07ddn80wWgVy7OzQGL
         12GjhF3ny8+Y9v3gcFFjdMVoldrNKFaD0WsvgyRjlciDNwYq7UOyonp5pBlIHtcZ4TO8
         HnOuinAygBHd+LyZ2e61pOD88Xy2mqoOB0/tofPzyrUQe7/X8evP3m86QgDrJcmQqmJ5
         BQ/w==
X-Gm-Message-State: AOAM533iZHCIJjnwukp78FcYbbqWPZ71BSMbG7r2B99Sa144LPJ4fLez
        YqHwNN8Xkio+gQyfLrLeAZk=
X-Google-Smtp-Source: ABdhPJxR1qr6/Cd9YaVZPMi2K5oS8OcjNgVv+lL7VJT2N8euSCYp+fVu98vCGo10I5CcfHoIUto+6w==
X-Received: by 2002:a05:6a00:a0e:b029:3c3:538:b4b8 with SMTP id p14-20020a056a000a0eb02903c30538b4b8mr4521016pfh.25.1628780901959;
        Thu, 12 Aug 2021 08:08:21 -0700 (PDT)
Received: from MASTER.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id w130sm3914261pfd.118.2021.08.12.08.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:08:21 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     hawk@kernel.org, brouer@redhat.com, davem@davemloft.net,
        toke@redhat.com, toke@toke.dk
Cc:     netdev@vger.kernel.org, Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next 0/2] samples: pktgen: enhance the usability of pktgen samples
Date:   Fri, 13 Aug 2021 00:08:11 +0900
Message-Id: <20210812150813.53124-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset improves the usability of pktgen samples by adding an option for
propagating the environment variable of normal user to sudo. And also adds the
missing IPv6 option to pktgen scripts.

Currently, all pktgen samples are able to use the environment variable instead
of optional parameters. However, it doesn't work appropriately when running
samples as normal user.

This is results of running sample as root and user:

    // running as root
    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample01_simple.sh -v -n 1
    Running... ctrl^C to stop

    // running as normal user
    $ DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample01_simple.sh -v -n 1
    [...]
    ERROR: Please specify output device

The reason why passing the environment varaible doesn't work properly when
running samples as normal user is that the environment variable of normal user
doesn't propagate to sudo (root_check_run_with_sudo)). So the first commit
solves this issue by using "-E" (--preserve-env) option of "sudo", which passes
normal user's existing environment variables.

Also, "sample04" and "sample05" are not working properly when running with IPv6
option parameter("-6"). Because the commit 0f06a6787e05 ("samples: Add an IPv6
"-6" option to the pktgen scripts") has omitted the addition of this option at
these samples. So the second commit adds missing IPv6 option to pktgen scripts.

Fixes: 0f06a6787e05 ("samples: Add an IPv6 "-6" option to the pktgen scripts")

Juhee Kang (2):
  samples: pktgen: pass the environment variable of normal user to sudo
  samples: pktgen: add missing IPv6 option to pktgen scripts

 samples/pktgen/functions.sh                       |  2 +-
 samples/pktgen/pktgen_sample04_many_flows.sh      | 12 +++++++-----
 samples/pktgen/pktgen_sample05_flow_per_thread.sh | 12 +++++++-----
 3 files changed, 15 insertions(+), 11 deletions(-)

--
2.30.2
