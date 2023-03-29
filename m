Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC8E6CF12A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjC2Rcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2Rca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:32:30 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04D249FA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:32:28 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3e390e23f83so347671cf.1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680111148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=degRtIhux6688TNvPjGrValnl+zQVaa8FMPKCKuIip4=;
        b=l+ub6hQlCTPhx+lc1TwKoFjsCDucXbNrm4NoAtTBM79YS4D97BGB+oyNuC78ex5g4r
         bbndmZTxAYwIhGhtTuIYTSHWx4MHJXdO1ggX974K6lgkZBAds4xupCmMrr1b55k3V78P
         pGB537wBkJmJrmhBENvht/H/oiRYB+iESD2kmRzJecP8bmB0q6as5bWHxRSOlv3+LEhC
         aovV3+dHpuKiBkKxDBgN0TIaEeQSevOGUfqINn1VCYrcSAJEXHvkMdf5AEm8ISQAz6UC
         ee6cm5BQRg7PjzYsb7KZcq3OsUwZ1NMYQp0FiMOpk/Pbzhh/pZGehrLIPN2KQGHWMJD3
         sxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680111148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=degRtIhux6688TNvPjGrValnl+zQVaa8FMPKCKuIip4=;
        b=dfTjNRIiB9A3GLWpo/OHMsvc6shHrGkVVnOfPUvk3ybAS/+Cw5usrQqDwYzxMhH2Li
         mTtR/EREaBVxhw/+YLye06HX3mrJAijiyHFFmhIOLnDA6+Me36JtIaHv+21Ai6SjE0Gr
         YNPli6MuTc9jZ7fpRb8gRpFReIMsCsNsMSLE2riwCrp+cDxd+A39xtJPdLjKMlXW+VsG
         DuPyqxN7naDWgd6dBFBzeUZPLeTl55rOaLnNhHrCtMhfXmyIxM62+5WSSib20Yr5b4C2
         AUXgP7P0CEFsMmUmMrSAPlH/nHBKd0cqApHP/5gP21SUmIWSHM4cH0TK6Y0gVAhb7RJv
         eaMQ==
X-Gm-Message-State: AAQBX9cizNkCMGjF5FA5dIHl6apI64Y2t5XfGRjEOuipr1m1eDmYB435
        PPHMVt7Bq57fZX5Mr0KCcObaIb7LphOrqRYLu5nQUw==
X-Google-Smtp-Source: AKy350ZG97y2PHkm8JbscxIe3xR7aXwx/HBfs0zpE7vkqubYp1GSW3IzXQNxYt/xRHVgJRI7xHoIUbgBDKqai525hGA=
X-Received: by 2002:a05:622a:1825:b0:3e2:3de:371f with SMTP id
 t37-20020a05622a182500b003e203de371fmr430450qtc.15.1680111147865; Wed, 29 Mar
 2023 10:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
In-Reply-To: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Wed, 29 Mar 2023 13:31:50 -0400
Message-ID: <CA+FuTSer3=W1TfStqqjGEswvvbz6Z4GOF6ix0QVaZdcgJxor6A@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 00/15] Introduce IDPF driver
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:07=E2=80=AFAM Pavan Kumar Linga
<pavan.kumar.linga@intel.com> wrote:
>
> This patch series introduces the Infrastructure Data Path Function (IDPF)
> driver. It is used for both physical and virtual functions. Except for
> some of the device operations the rest of the functionality is the same
> for both PF and VF. IDPF uses virtchnl version2 opcodes and structures
> defined in the virtchnl2 header file which helps the driver to learn
> the capabilities and register offsets from the device Control Plane (CP)
> instead of assuming the default values.
>
> The format of the series follows the driver init flow to interface open.
> To start with, probe gets called and kicks off the driver initialization
> by spawning the 'vc_event_task' work queue which in turn calls the
> 'hard reset' function. As part of that, the mailbox is initialized which
> is used to send/receive the virtchnl messages to/from the CP. Once that i=
s
> done, 'core init' kicks in which requests all the required global resourc=
es
> from the CP and spawns the 'init_task' work queue to create the vports.
>
> Based on the capability information received, the driver creates the said
> number of vports (one or many) where each vport is associated to a netdev=
.
> Also, each vport has its own resources such as queues, vectors etc.
> From there, rest of the netdev_ops and data path are added.
>
> IDPF implements both single queue which is traditional queueing model
> as well as split queue model. In split queue model, it uses separate queu=
e
> for both completion descriptors and buffers which helps to implement
> out-of-order completions. It also helps to implement asymmetric queues,
> for example multiple RX completion queues can be processed by a single
> RX buffer queue and multiple TX buffer queues can be processed by a
> single TX completion queue. In single queue model, same queue is used
> for both descriptor completions as well as buffer completions. It also
> supports features such as generic checksum offload, generic receive
> offload (hardware GRO) etc.
>
> Pavan Kumar Linga (15):
>   virtchnl: add virtchnl version 2 ops
>   idpf: add module register and probe functionality
>   idpf: add controlq init and reset checks
>   idpf: add core init and interrupt request
>   idpf: add create vport and netdev configuration
>   idpf: continue expanding init task
>   idpf: configure resources for TX queues
>   idpf: configure resources for RX queues
>   idpf: initialize interrupts and enable vport
>   idpf: add splitq start_xmit
>   idpf: add TX splitq napi poll support
>   idpf: add RX splitq napi poll support
>   idpf: add singleq start_xmit and napi poll
>   idpf: add ethtool callbacks
>   idpf: configure SRIOV and add other ndo_ops
>
>  .../device_drivers/ethernet/intel/idpf.rst    |   46 +
>  drivers/net/ethernet/intel/Kconfig            |   11 +
>  drivers/net/ethernet/intel/Makefile           |    1 +
>  drivers/net/ethernet/intel/idpf/Makefile      |   18 +
>  drivers/net/ethernet/intel/idpf/idpf.h        |  734 +++
>  .../net/ethernet/intel/idpf/idpf_controlq.c   |  644 +++
>  .../net/ethernet/intel/idpf/idpf_controlq.h   |  131 +
>  .../ethernet/intel/idpf/idpf_controlq_api.h   |  190 +
>  .../ethernet/intel/idpf/idpf_controlq_setup.c |  175 +
>  drivers/net/ethernet/intel/idpf/idpf_dev.c    |  179 +
>  drivers/net/ethernet/intel/idpf/idpf_devids.h |   10 +
>  .../net/ethernet/intel/idpf/idpf_ethtool.c    | 1325 +++++
>  .../ethernet/intel/idpf/idpf_lan_pf_regs.h    |  124 +
>  .../net/ethernet/intel/idpf/idpf_lan_txrx.h   |  293 +
>  .../ethernet/intel/idpf/idpf_lan_vf_regs.h    |  128 +
>  drivers/net/ethernet/intel/idpf/idpf_lib.c    | 2551 +++++++++
>  drivers/net/ethernet/intel/idpf/idpf_main.c   |   85 +
>  drivers/net/ethernet/intel/idpf/idpf_mem.h    |   20 +
>  .../ethernet/intel/idpf/idpf_singleq_txrx.c   | 1262 +++++
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 4850 +++++++++++++++++
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  838 +++
>  drivers/net/ethernet/intel/idpf/idpf_vf_dev.c |  180 +
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 3802 +++++++++++++
>  drivers/net/ethernet/intel/idpf/virtchnl2.h   | 1153 ++++
>  .../ethernet/intel/idpf/virtchnl2_lan_desc.h  |  644 +++
>  25 files changed, 19394 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/inte=
l/idpf.rst
>  create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq_api.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq_setup.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_dev.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_devids.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_ethtool.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lib.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_mem.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_txrx.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_txrx.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
>  create mode 100644 drivers/net/ethernet/intel/idpf/virtchnl2.h
>  create mode 100644 drivers/net/ethernet/intel/idpf/virtchnl2_lan_desc.h
>
> --
> 2.37.3

Reviewed-by: David Decotigny <decot@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>

Tested-by: David Decotigny <decot@google.com>
Tested-by: Willem de Bruijn <willemb@google.com>

We have been working with this driver at Google for well over a year
through multiple revisions.

The current version runs in continuous testing with both functional
(RSS, checksum, TSO/USO, HW-GRO, etc., many from
tools/testing/selftests/net) and performance (github.com/google/neper
tcp_stream, tcp_rr, etc. in variety of #threads and #flows
configurations) tests, including ASAN, lockdep. The driver is also
exercised continuously with more varied application workloads.
