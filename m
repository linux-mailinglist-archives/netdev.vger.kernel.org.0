Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB5BAE3AF
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 08:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730875AbfIJG0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 02:26:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45127 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730448AbfIJG0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 02:26:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id l16so17516955wrv.12;
        Mon, 09 Sep 2019 23:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvMyp24fNfOUnjJclwKWLt3KZ/Su+dOW9nHqfue/1vY=;
        b=LCtFLMn512p+CZPiVTU6ZlRoyyUn7SJhuUn7fc+hNj3/u99Y0EVRmDTEd6Tw/bmwm0
         prQYTsmPrZxz60MMvAEHAoPX6elvPbpq3VfpSGjkz2IPkTvbIlEl4TtjXnzULLwA0r++
         UPZe4zJ4+/L/r73NerZoup0XQo15eEVaMEge2gGcIQpGnzwRdQbaSfnRwY+JgQ/sb0r8
         vj2H2GPsgpOSuO1u71vuSJze2HkdsVRhDrlgRG9hpMXr1sLDFjmYJ513hOGmY+PuR1dY
         4iSsABY3lCRo1MxVVpBvadAxBQbaECda2BXYjduUTVlybZGwKij0tI1YSvah3dBMD5BX
         W4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvMyp24fNfOUnjJclwKWLt3KZ/Su+dOW9nHqfue/1vY=;
        b=eTW9Ex/KlzaHrGnN54fQlH/1OA73XDHF9Zs7416Ifiv4m+lWGJOSR4GcIGtqIA40rV
         HCnsl0XaNwZLrDI06b3C+c1CTjh1TLwTz3gpn6Ce3sbqeDndu11g7AB4H98dP65DKXlx
         Tzf75cHe3qvbgrUso72otCxBEapGkhE6snaP8QIVXeqePYQ/OaUgQbTkSgsCziZmqEuJ
         S7kQUfQcSryGFm+g0foxGr8i14lqkCajAIjDPCXBoCkRz0P7sRyUIkmZh4g87n4mj84t
         uuEObpULZ9wYbJrdewREwBxjjKmJHehWiqwrZRibfoDeBsCSsKqk5baRBH982ba4LXNI
         20YQ==
X-Gm-Message-State: APjAAAVIKVOVu8367m0oYAamW57+/sqsvVpYj4dlzOy8uKwf6Ml+K0Rm
        eS1Azo/BbKCN+UFeW7vR3iHocpeBSMGq1ruiNIk=
X-Google-Smtp-Source: APXvYqyygkFNv3F7rtjsVlSOjyzR8UvLcnl8cnDuspxjn9PjSkuEkd2LVbEyvy2uMkCD7Qu6ZS8fhB5HZGzhVtLRWE8=
X-Received: by 2002:a5d:45c3:: with SMTP id b3mr24776880wrs.207.1568096798562;
 Mon, 09 Sep 2019 23:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <201909091802.pU2vj2DA%lkp@intel.com> <20190910035421.GB1778@archlinux-threadripper>
In-Reply-To: <20190910035421.GB1778@archlinux-threadripper>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 10 Sep 2019 14:26:27 +0800
Message-ID: <CADvbK_e0F49oNw=erZLCnkYLYP2fvYy92gih0nFpM19JoL=1tQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] sctp: add pf_expose per netns and sock and asoc
To:     Nathan Chancellor <natechancellor@gmail.com>,
        linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>
Cc:     kbuild@01.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 11:54 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Hi Xin,
>
> The 0day team has been doing clang builds for us and this warning popped
> up. Let me know if you have any questions.
>
> On Mon, Sep 09, 2019 at 06:44:47PM +0800, kbuild test robot wrote:
> > CC: kbuild-all@01.org
> > In-Reply-To: <00fb06e74d8eedeb033dad83de18380bf6261231.1568015756.git.lucien.xin@gmail.com>
> > References: <00fb06e74d8eedeb033dad83de18380bf6261231.1568015756.git.lucien.xin@gmail.com>
> > TO: Xin Long <lucien.xin@gmail.com>
> > CC: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
> > CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
> >
> > Hi Xin,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on net-next/master]
> >
> > url:    https://github.com/0day-ci/linux/commits/Xin-Long/sctp-update-from-rfc7829/20190909-160115
> > config: x86_64-rhel-7.6 (attached as .config)
> > compiler: clang version 10.0.0 (git://gitmirror/llvm_project 45a3fd206fb06f77a08968c99a8172cbf2ccdd0f)
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64
> >
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> net/sctp/associola.c:799:24: warning: use of logical '&&' with constant operand [-Wconstant-logical-operand]
> >                    if (transport->state && SCTP_UNCONFIRMED &&
> >                                         ^  ~~~~~~~~~~~~~~~~
> >    net/sctp/associola.c:799:24: note: use '&' for a bitwise operation
> >                    if (transport->state && SCTP_UNCONFIRMED &&
> >                                         ^~
> >                                         &
> >    net/sctp/associola.c:799:24: note: remove constant to silence this warning
> >                    if (transport->state && SCTP_UNCONFIRMED &&
> >                                        ~^~~~~~~~~~~~~~~~~~~
> >    1 warning generated.
> >
> > vim +799 net/sctp/associola.c
> >
> >    775
> >    776        /* Engage in transport control operations.
> >    777         * Mark the transport up or down and send a notification to the user.
> >    778         * Select and update the new active and retran paths.
> >    779         */
> >    780        void sctp_assoc_control_transport(struct sctp_association *asoc,
> >    781                                          struct sctp_transport *transport,
> >    782                                          enum sctp_transport_cmd command,
> >    783                                          sctp_sn_error_t error)
> >    784        {
> >    785                struct sctp_ulpevent *event;
> >    786                struct sockaddr_storage addr;
> >    787                int spc_state = 0;
> >    788                bool ulp_notify = true;
> >    789
> >    790                /* Record the transition on the transport.  */
> >    791                switch (command) {
> >    792                case SCTP_TRANSPORT_UP:
> >    793                        /* If we are moving from UNCONFIRMED state due
> >    794                         * to heartbeat success, report the SCTP_ADDR_CONFIRMED
> >    795                         * state to the user, otherwise report SCTP_ADDR_AVAILABLE.
> >    796                         */
> >    797                        if (transport->state == SCTP_PF && !asoc->pf_expose)
> >    798                                ulp_notify = false;
> >  > 799                        if (transport->state && SCTP_UNCONFIRMED &&
>
> I assume this && should either be a '&' or '=='?
Right, it should have been "==". It was changed unintentionally
when I swapped the position of 'state' and 'SCTP_UNCONFIRMED'.

Thanks, will post v2 after others' review.

>
> >    800                            SCTP_HEARTBEAT_SUCCESS == error)
> >    801                                spc_state = SCTP_ADDR_CONFIRMED;
> >    802                        else
> >    803                                spc_state = SCTP_ADDR_AVAILABLE;
> >    804                        transport->state = SCTP_ACTIVE;
> >    805                        break;
> >    806
> >    807                case SCTP_TRANSPORT_DOWN:
> >    808                        /* If the transport was never confirmed, do not transition it
> >    809                         * to inactive state.  Also, release the cached route since
> >    810                         * there may be a better route next time.
> >    811                         */
> >    812                        if (transport->state != SCTP_UNCONFIRMED) {
> >    813                                transport->state = SCTP_INACTIVE;
> >    814                                spc_state = SCTP_ADDR_UNREACHABLE;
> >    815                        } else {
> >    816                                sctp_transport_dst_release(transport);
> >    817                                ulp_notify = false;
> >    818                        }
> >    819                        break;
> >    820
> >    821                case SCTP_TRANSPORT_PF:
> >    822                        transport->state = SCTP_PF;
> >    823                        if (!asoc->pf_expose)
> >    824                                ulp_notify = false;
> >    825                        else
> >    826                                spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
> >    827                        break;
> >    828
> >    829                default:
> >    830                        return;
> >    831                }
> >    832
> >    833                /* Generate and send a SCTP_PEER_ADDR_CHANGE notification
> >    834                 * to the user.
> >    835                 */
> >    836                if (ulp_notify) {
> >    837                        memset(&addr, 0, sizeof(struct sockaddr_storage));
> >    838                        memcpy(&addr, &transport->ipaddr,
> >    839                               transport->af_specific->sockaddr_len);
> >    840
> >    841                        event = sctp_ulpevent_make_peer_addr_change(asoc, &addr,
> >    842                                                0, spc_state, error, GFP_ATOMIC);
> >    843                        if (event)
> >    844                                asoc->stream.si->enqueue_event(&asoc->ulpq, event);
> >    845                }
> >    846
> >    847                /* Select new active and retran paths. */
> >    848                sctp_select_active_and_retran_path(asoc);
> >    849        }
> >    850
> >
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
> Cheers,
> Nathan
