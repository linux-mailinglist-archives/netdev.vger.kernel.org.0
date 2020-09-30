Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B2627E0E1
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 08:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgI3GLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 02:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI3GLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 02:11:19 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB47DC061755;
        Tue, 29 Sep 2020 23:11:18 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v12so372925wmh.3;
        Tue, 29 Sep 2020 23:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bs1ORnIvUNDWol50FS3a32D8Yz11CkKYmEZJ9EQk5GI=;
        b=mK4p4oHe8XnBOnOssIm/Y/wUV92teciLxgdde4XCxca4hJoqCaOzcvpug9IM7vPJ1U
         YrU0XD5qMvXpQc9TLRUORsWSsrIX7RBCyuo6kOwfTAALvTMRfSOHpW61pvgRkkTwUIBC
         IcomCpHQNuBsA9zXv4PadHValYrPAukOd4r/TnKf5aofXeblIz/7ASOO6ATEFuOEfbZU
         aqTW5o8OLDLSLaoChxwaG6edZXZcHuCMFFXWhpPQwoufh+7DhfzeuQyNybLXJ1QlApvI
         V4mkLbO8pr+TmDqaBy33MX1kykjV1Vt6x/AuTP4RlBcX0txmqhzb433WFBDwhLCI4xbz
         7/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bs1ORnIvUNDWol50FS3a32D8Yz11CkKYmEZJ9EQk5GI=;
        b=ftOPrtZQNxJih8oIf2C585Y0/AA3YmaFpJOwdKOeL89NwJ0occ5jOWReXNIjaliBKO
         IP14kOwwGtXuyclcjsLq74kf3MFuiLnkV21ReJiBzQ0GyTO0m1DRdOUoZvq19a1/QmS/
         lBMutWlzwChM1SLEhreOHHUkbnhuVWaqEbzblw5N7iKpeaq9mBrT+eilZn9EdtPpyNua
         MVddNdYPjVWceb4cY2OrHkDks3XCLEl4vxiB3oMMFFsX/jCIoch3nW8NMMY9yTRWdFTt
         C+N8J+u2oavGloV/km2tAXZPfEOmh1m9w6SoVtQ/mvdSvOh19cV8beZ9SP9Jmwj+h3Bt
         9VJA==
X-Gm-Message-State: AOAM532/S5KCDoOh+IemLhadLM1Chid++ad3DMy2sXTH/h7XRgQlmklr
        Jps932boQYVv/8Brq3neZOLqvW2yF+wPLMnFDrmRGD4Qv+Q=
X-Google-Smtp-Source: ABdhPJw2mnUXHH9l2NgiKnpyVgpbiU81eMuGbf6ClgQlIL4O5H4UQUH2gdeYezWT/BEXHp/b2rKXZO+s4xDaZkWvb8I=
X-Received: by 2002:a05:600c:283:: with SMTP id 3mr1106739wmk.110.1601446277521;
 Tue, 29 Sep 2020 23:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <82b358f40c81cfdecbfc394113be40fd1f682043.1601387231.git.lucien.xin@gmail.com>
 <202009300036.j5lTE8CI-lkp@intel.com>
In-Reply-To: <202009300036.j5lTE8CI-lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 30 Sep 2020 14:26:31 +0800
Message-ID: <CADvbK_cKHg=TD7h=Ddaon_T0t7+G81Pg_EJ2CeOtvq7TcQKO=Q@mail.gmail.com>
Subject: Re: [PATCH net-next 13/15] sctp: support for sending packet over udp4 sock
To:     kernel test robot <lkp@intel.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        kbuild-all@lists.01.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 12:26 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20200929-215159
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 280095713ce244e8dbdfb059cdca695baa72230a
> config: ia64-randconfig-r014-20200929 (attached as .config)
> compiler: ia64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/a1016fd4a55f176fcc2eae05052a61ad7d5a142b
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20200929-215159
>         git checkout a1016fd4a55f176fcc2eae05052a61ad7d5a142b
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=ia64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    net/sctp/protocol.c: In function 'sctp_udp_sock_start':
> >> net/sctp/protocol.c:894:11: error: 'struct udp_port_cfg' has no member named 'local_ip6'; did you mean 'local_ip'?
>      894 |  udp_conf.local_ip6 = in6addr_any;
>          |           ^~~~~~~~~
>          |           local_ip
>
> vim +894 net/sctp/protocol.c
>
> a330bee1c278f8 Xin Long 2020-09-29  870
> 140bb5309cf409 Xin Long 2020-09-29  871  int sctp_udp_sock_start(struct net *net)
> 140bb5309cf409 Xin Long 2020-09-29  872  {
> 140bb5309cf409 Xin Long 2020-09-29  873         struct udp_tunnel_sock_cfg tuncfg = {NULL};
> 140bb5309cf409 Xin Long 2020-09-29  874         struct udp_port_cfg udp_conf = {0};
> 140bb5309cf409 Xin Long 2020-09-29  875         struct socket *sock;
> 140bb5309cf409 Xin Long 2020-09-29  876         int err;
> 140bb5309cf409 Xin Long 2020-09-29  877
> 140bb5309cf409 Xin Long 2020-09-29  878         udp_conf.family = AF_INET;
> 140bb5309cf409 Xin Long 2020-09-29  879         udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
> 140bb5309cf409 Xin Long 2020-09-29  880         udp_conf.local_udp_port = htons(net->sctp.udp_port);
> 140bb5309cf409 Xin Long 2020-09-29  881         err = udp_sock_create(net, &udp_conf, &sock);
> 140bb5309cf409 Xin Long 2020-09-29  882         if (err)
> 140bb5309cf409 Xin Long 2020-09-29  883                 return err;
> 140bb5309cf409 Xin Long 2020-09-29  884
> 140bb5309cf409 Xin Long 2020-09-29  885         tuncfg.encap_type = 1;
> 140bb5309cf409 Xin Long 2020-09-29  886         tuncfg.encap_rcv = sctp_udp_rcv;
> a330bee1c278f8 Xin Long 2020-09-29  887         tuncfg.encap_err_lookup = sctp_udp_err_lookup;
> 140bb5309cf409 Xin Long 2020-09-29  888         setup_udp_tunnel_sock(net, sock, &tuncfg);
> 140bb5309cf409 Xin Long 2020-09-29  889         net->sctp.udp4_sock = sock->sk;
> 140bb5309cf409 Xin Long 2020-09-29  890
> cff8956126170d Xin Long 2020-09-29  891         memset(&udp_conf, 0, sizeof(udp_conf));
> cff8956126170d Xin Long 2020-09-29  892
> cff8956126170d Xin Long 2020-09-29  893         udp_conf.family = AF_INET6;
> cff8956126170d Xin Long 2020-09-29 @894         udp_conf.local_ip6 = in6addr_any;
> cff8956126170d Xin Long 2020-09-29  895         udp_conf.local_udp_port = htons(net->sctp.udp_port);
> cff8956126170d Xin Long 2020-09-29  896         udp_conf.use_udp6_rx_checksums = true;
> cff8956126170d Xin Long 2020-09-29  897         udp_conf.ipv6_v6only = true;
> cff8956126170d Xin Long 2020-09-29  898         err = udp_sock_create(net, &udp_conf, &sock);
> cff8956126170d Xin Long 2020-09-29  899         if (err) {
> cff8956126170d Xin Long 2020-09-29  900                 udp_tunnel_sock_release(net->sctp.udp4_sock->sk_socket);
> cff8956126170d Xin Long 2020-09-29  901                 net->sctp.udp4_sock = NULL;
> cff8956126170d Xin Long 2020-09-29  902                 return err;
> cff8956126170d Xin Long 2020-09-29  903         }
> cff8956126170d Xin Long 2020-09-29  904
> cff8956126170d Xin Long 2020-09-29  905         tuncfg.encap_type = 1;
> cff8956126170d Xin Long 2020-09-29  906         tuncfg.encap_rcv = sctp_udp_rcv;
> a330bee1c278f8 Xin Long 2020-09-29  907         tuncfg.encap_err_lookup = sctp_udp_err_lookup;
> cff8956126170d Xin Long 2020-09-29  908         setup_udp_tunnel_sock(net, sock, &tuncfg);
> cff8956126170d Xin Long 2020-09-29  909         net->sctp.udp6_sock = sock->sk;
#if IS_ENABLED(CONFIG_IPV6) is needed for this part.

Thanks.
> cff8956126170d Xin Long 2020-09-29  910
> 140bb5309cf409 Xin Long 2020-09-29  911         return 0;
> 140bb5309cf409 Xin Long 2020-09-29  912  }
> 140bb5309cf409 Xin Long 2020-09-29  913
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
