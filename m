Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2032D3C6682
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 00:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhGLWup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 18:50:45 -0400
Received: from mx5.ucr.edu ([138.23.62.67]:32576 "EHLO mx5.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhGLWuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 18:50:44 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2021 18:50:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1626130076; x=1657666076;
  h=mime-version:from:date:message-id:subject:to;
  bh=ifSIfnXd8bcmUUo9s673T74JcRVcrbFp1qn+wwKzU2I=;
  b=FK9w1jgUR97OH6OrYUlJKsy2qB5y09VFeqBiSl4muqs5oQwUVR8Id+pT
   OhBmddccJG7MC66Nbm4Joe0OzGhT20Pwm2kv3GSKSdFaUYiGEiPPugzuG
   LKwmvS4LRu/AebUKVebuHgCJFTzwR8I8RQWjggrWUzjL3IgzbK/B3+yvT
   TPZj77lxLswAQBZmKBnYC2Bp3mZW/99GsJWZOqjOzzeJs+ZWgfUhJ7nVH
   a6Xi1Ai2skU+S+84HX1Bp+2qA5GJPWvmwfdPa2soxO0Q4z7wvSq8xbBm5
   zFlyx12PT0TY7L+TQlWlKef742IO742OWcHJDPWw+r1yynZmGaimLKOO0
   w==;
IronPort-SDR: XY9oznKVNRqeOkvL1eu4FKrc9XvmiPM+fI/TXXKFrfnw4biTsO0BLB+WJD9i7pR2H0bnE4KE1U
 pgADt+CN2UqtQnMYYZn/NfOO7M5QxUYeezPARFq90+AP86SNtzbBVU8zOb7LCyeENgIHbuyUwI
 bLX2XpfPPoA/FMbn5dUzJH8xD9nT2oaVb71jkiQt4rG6UAL74DZYpyUQR1/mNWB4WecyTx2Jzn
 ervAYkkJg3KfVzRjKX3D0jmixsNgpyTEUGXhv5vYL8L9+nWt3nC+yu55YDGJogab11mfYOHrNk
 QlE=
X-IPAS-Result: =?us-ascii?q?A2FnCADaw+xgdManVdFagQmBWYN4hTSRWoMnAZJ0hT+Bf?=
 =?us-ascii?q?AIJAQEBD0EEAQGHTwIlNAkOAgQBAQEBAwIDAQEBAQUBAQYBAQEBAQEFBAEBA?=
 =?us-ascii?q?hABb4UvRoI4IoQNEQR4DwImAiQSAQUBIzSCT4MIBZw3gQQ9izJ/M4EBiC0BC?=
 =?us-ascii?q?Q2BYxJ+KocJgmiEIYIpgUuLCIJkBINmVYETgT9AUwEBAZ8HnQUBBgKDChyeN?=
 =?us-ascii?q?CuDY5IYkFctlESBEZ9QhUkQI4E4ghUzGiV/BmeBTE8ZDod/lQ4kZwIGCgEBA?=
 =?us-ascii?q?wmMNQEB?=
IronPort-PHdr: A9a23:+wWBmRIGq0Wtcp++ZNmcuJNmWUAX0o4c3iYr45Yqw4hDbr6kt8y7e
 hCFvbM01hSZBs2bs6sC17OH9fi4GCQp2tWoiDg6aptCVhsI2409vjcLJ4q7M3D9N+PgdCcgH
 c5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFRrhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTajfb9+N
 gi6oRveusQVj4ZpN6I9xgfUrndSdOla2GdlKUiPkxrg48u74YJu/TlXt/897cBLTL/0f74/T
 bxWDTQmN3466cj2vhTdTgWB+2URXHwOnhVHHwbK4hf6XozssiThrepyxDOaPcztQr8qXzmp8
 rpmRwXpiCcDMD457X3Xh8lth69VvB6tuxpyyJPSbYqINvRxY7ndcMsVSmRBUMhfVDFPDJ2gY
 IYUE+oNIfxVo5Xhq1cSrxazAxSnCuP1yj9Pg3/7xaw10+U7HgHBwAMgH8wBsHLJp9r2M6cST
 P2+wa7HzDTCaPNWxCvx5JXKfx06vPGDQahwfdDPxkYyCgPIl1OdopHqMD2JzOoCqXSb7/Z+W
 uK1jW4qsx98rzivyMoohYfHiIEYx1HE+Ch93Is7KsC0RU5lbdOnE5ZduCOXOopqT84hTWxkp
 Sg0x6MEtJC7YSUG1okqygDZZveacIaI+gruWPiNLTp8nn5oe7Kyiwyv/UWhyODwTNS43VJJo
 ydDj9LCrGoC1wbJ5ciCUvZ9+0Ch1iuR2A3L8eFEJFw0lbLcK5483r48jpoTvlrHHi/xgEj2i
 bWZdkQg+uSx7OTnY6jqqoaSN4NpjgzzMb4imsO4AeQ/PQgOW3aU9f6g273k+E31WLRKjvson
 anFqJ3WO9gXq6qjDwJW0osv8QuzAjak3dgCgHUKKFFIdAqCj4fzOlHOJP74De24g1SpiDpqy
 PHHPrr8ApnRM3TOkqzsfath5E5G0gY8081Q549MBrEbPP3zQlPxtMDfDhIhNQy73frnB8hj2
 YMAQm+PHKCZP73IsVOS5eIgPfOMZIkLtzb5MfQl4OTujXBq0WMaKKqkx50abFigE/JpPlmDZ
 nztkpENHCNCugs4Ufyvg1SEeSBcamz0XK8m4Dw/ToW8AsOLQI2xjLGf9Dm0E4cQZW1cDF2IV
 3DyeMHMQOsFYiafCtFunyZCVrW7TYIlkxa0u1zU0b1ie9rV8yoTtZ/lnOpy+qWHhQM16GQtU
 OyA2HvLQm1pyDBbDwQq1bxy9BQugmyI1rJ11qQwKA==
IronPort-HdrOrdr: A9a23:aoKbJKmq9kAelGqGNXXl8WfrANHpDfIl3DAbv31ZSRFFG/Fw9v
 re+8jzuiWE6wr5NEtBpTniAsi9qBHnhPxICOAqVN/IYOCMghrMEGgN1/qH/9QiIUDDHyxmv5
 uIv5IQNDQ4NzQVsfrH
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="225448052"
Received: from mail-oi1-f198.google.com ([209.85.167.198])
  by smtpmx5.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jul 2021 15:40:40 -0700
Received: by mail-oi1-f198.google.com with SMTP id t22-20020a0568081596b029023a41b03dc9so14064896oiw.1
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 15:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ifSIfnXd8bcmUUo9s673T74JcRVcrbFp1qn+wwKzU2I=;
        b=Hk/dqt4Qdfz7VqEo3VmtWy678I5qpO1K6fxAZ6M6wjadBw1L4WFcUTW8c7+4/pRrVI
         8MhqKMXF4v1xcxPlO5NEYj+wDBInWqr3SKsnR886Ol/+4mO6BfsR93kGuMZokf1dQNf+
         2f3yqIFw8BwLDy/KKtvGkdwFU+V28uRABwWJwMWh1ToBYFUfCCFvBs512s0PDcsBBbTI
         sNIujjbS36bKmY9DiYB594Q351OtKtNJDHoGupLv5erGdNBbvpkfnpSUyxBajSpU8bU2
         e6CXLlj1Agf61Kln1lQawANEh3c/WHmmX47RWmnXT37RTVodCYrCHMzyLuhyqgN9RMzz
         6ckA==
X-Gm-Message-State: AOAM5336nqSbWyh+T9KLFHYSufGEYWHTNeb3XVzD82oYhw/qlWccJ6qL
        tg+RJm+JXA8EH7oKXOZyVNP/GEH1e5d0vknUxZdTAkYz07PNhIgVTxNUvGwv1wsE9b9isvW4noW
        Ona7y4rCe/YVSKcS90/AHLsnHheiAVNDztw==
X-Received: by 2002:a05:6808:485:: with SMTP id z5mr779655oid.173.1626129639557;
        Mon, 12 Jul 2021 15:40:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZfGqHGQmRnC5RP4bUAOLDwdo88/vNQTwKvTmt2dHYkvb/X7zkHNffTLqVK0CNQp9UGHGV5fGxZhg3/cLae1Y=
X-Received: by 2002:a05:6808:485:: with SMTP id z5mr779640oid.173.1626129639340;
 Mon, 12 Jul 2021 15:40:39 -0700 (PDT)
MIME-Version: 1.0
From:   Xiaochen Zou <xzou017@ucr.edu>
Date:   Mon, 12 Jul 2021 15:40:46 -0700
Message-ID: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
Subject: Use-after-free access in j1939_session_deactivate
To:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
It looks like there are multiple use-after-free accesses in
j1939_session_deactivate()

static bool j1939_session_deactivate(struct j1939_session *session)
{
bool active;

j1939_session_list_lock(session->priv);
active = j1939_session_deactivate_locked(session); //session can be freed inside
j1939_session_list_unlock(session->priv); // It causes UAF read and write

return active;
}

session can be freed by
j1939_session_deactivate_locked->j1939_session_put->__j1939_session_release->j1939_session_destroy->kfree.
Therefore it makes the unlock function perform UAF access.


Best,
Xiaochen Zou
Department of Computer Science & Engineering
University of California, Riverside
