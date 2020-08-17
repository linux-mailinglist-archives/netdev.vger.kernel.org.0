Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BC5246EBF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 19:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgHQRfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 13:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387770AbgHQQca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 12:32:30 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AFAC061343
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 09:32:29 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id o23so18507841ejr.1
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 09:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tVOlBPcVZ/MzMiL6He5n035C+p6pS5a2mSrnGwQQ1+k=;
        b=FGG6BtUjs7Qx29iBsLCSi3ZV/1+funzD3UoWTE5ULfkQEFEOPGzZBlsTGGhsLkG0W1
         jroF5nqJU8e2oz6a9h7+H2dd0wvdt8kOHZiGHOr+3akLD4BlKpsov6TKLEKV2H9UicmZ
         rhgcR2DFnsNSuo+yn6vlLRTbgy2lg8hLicHw3abqMRgfbyeUVA78vOJXtEk2P80vVhnL
         R/rbco7bECPL4rbeWU9DLwa1x/e6aPYJLQkvdGZkJH/OT4Yv3z6pL+2PSfULgBmYQxD/
         1MLX4qI9qSm+bpoavQwY69B5PmBIebrJyHzqnH9qk7dBeLHtWMgNC5dpIvtGj1DGNxVb
         Kxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tVOlBPcVZ/MzMiL6He5n035C+p6pS5a2mSrnGwQQ1+k=;
        b=AeXlKP4ttntZyHnyV5dWMEsbzuJEMJOIlOdwXIr63opI6Z6mVdoPKYawWOfZE5/Hea
         Brw7CzJ/nz9uuVdNddpbYCnQozFymuGGKnYrn9ygLc93KZ4LV/rxZiuY7s4b5PsD4R70
         ObBXf/Aw/jARlvZsn9S9D64eQfqpX/s0ZsHonn30B6WcThkQIGg9IAPBssFU5HG2kk9Y
         MX4G0MdG1iwbMYUE0ch+XTUWftOh3cqqbCNKNJMULzE7h8z4nUOdXTMpwAVppH4u8RMK
         J0sMFygkkN1VtjrEFjzq9UnL1sm9M47eMkCXeYu+gPKBXi0k/ZmOc+wcUcfY0eDbSfEq
         u+mA==
X-Gm-Message-State: AOAM532c0HNU53XMcEbMc4HlDzHdYT7TMxlna7ppvigzV1vLjhDBZoEN
        lfGDSWuEP850GVMyf6jmYaQ=
X-Google-Smtp-Source: ABdhPJwaLM09Sug1ATFth9AkFgx72ETX3+G0lOFBmU1vIs6oQlkqn7k03nIyamGb5D3Qo7xtHA16eg==
X-Received: by 2002:a17:906:7153:: with SMTP id z19mr15458334ejj.319.1597681944774;
        Mon, 17 Aug 2020 09:32:24 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id t6sm14568045ejc.40.2020.08.17.09.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 09:32:24 -0700 (PDT)
Date:   Mon, 17 Aug 2020 19:32:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: devlink-sb on ocelot switches
Message-ID: <20200817163222.opf576vyvapk4bqm@skbuf>
References: <20200814104228.eidqu7fd7mfyur5n@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814104228.eidqu7fd7mfyur5n@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So after some more fiddling, it looks like I got the diagram wrong.
Here's how the switch really consumes resources. 4 lookups in parallel,
they are ORed in 2 pairs (ingress with egress forms a pair), and the
result is ANDed. The consumptions for ingress and egress are really
completely independent.

                          Frame forwarding decision taken
                                       |
                                       |
                                       v
       +--------------------+--------------------+--------------------+
       |                    |                    |                    |
       v                    v                    v                    v
 Ingress memory       Egress memory        Ingress frame        Egress frame
     check                check           reference check      reference check
       |                    |                    |                    |
       v                    v                    v                    v
  BUF_Q_RSRV_I   ok    BUF_Q_RSRV_E   ok    REF_Q_RSRV_I   ok     REF_Q_RSRV_E   ok
(src port, prio) -+  (dst port, prio) -+  (src port, prio) -+   (dst port, prio) -+
       |          |         |          |         |          |         |           |
       | exceeded |         | exceeded |         | exceeded |         | exceeded  |
       |          |         |          |         |          |         |           |
       v          |         v          |         v          |         v           |
  BUF_P_RSRV_I  ok|    BUF_P_RSRV_E  ok|    REF_P_RSRV_I  ok|    REF_P_RSRV_E   ok|
   (src port) ----+     (dst port) ----+     (src port) ----+     (dst port) -----+
       |          |         |          |         |          |         |           |
       | exceeded |         | exceeded |         | exceeded |         | exceeded  |
       |          |         |          |         |          |         |           |
       v          |         v          |         v          |         v           |
 BUF_PRIO_SHR_I ok|   BUF_PRIO_SHR_E ok|   REF_PRIO_SHR_I ok|   REF_PRIO_SHR_E  ok|
     (prio) ------+       (prio) ------+       (prio) ------+       (prio) -------+
       |          |         |          |         |          |         |           |
       | exceeded |         | exceeded |         | exceeded |         | exceeded  |
       |          |         |          |         |          |         |           |
       v          |         v          |         v          |         v           |
 BUF_COL_SHR_I  ok|   BUF_COL_SHR_E  ok|   REF_COL_SHR_I  ok|   REF_COL_SHR_E   ok|
      (dp) -------+        (dp) -------+        (dp) -------+        (dp) --------+
       |          |         |          |         |          |         |           |
       | exceeded |         | exceeded |         | exceeded |         | exceeded  |
       |          |         |          |         |          |         |           |
       v          v         v          v         v          v         v           v
      fail     success     fail     success     fail     success     fail      success
       |          |         |          |         |          |         |           |
       v          v         v          v         v          v         v           v
       +-----+----+         +-----+----+         +-----+----+         +-----+-----+
             |                    |                    |                    |
             +-------> OR <-------+                    +-------> OR <-------+
                        |                                        |
                        v                                        v
                        +----------------> AND <-----------------+
                                            |
                                            v
                                    FIFO drop / accept

Something which isn't explicitly said in devlink-sb is whether a pool
bound to a port-TC is allowed to spill over into the port pool. And
whether the port pool, in turn, is allowed to spill over into something
else (a shared pool)?

If they are, then I could expose BUF_P_RSRV_I (buffer reservation per
ingress port) as the threshold of the port pool, BUF_Q_RSRV_I and
BUF_Q_RSRV_E (buffer reservations per QoS class of ingress, and egress,
ports) as port-TC pools, and I could implicitly configure the remaining
sharing watermarks to consume the rest of the memory available in the
pool.

But by looking at some of the selftests, I don't see any clear
indication of a test where the occupancy of the port-TC exceeds the size
of that pool, and what should happen in that case.  Just a vague hint,
in tools/testing/selftests/drivers/net/mlxsw/sch_ets.sh, that once the
port-TC pool threshold has been exceeded, the excess should be simply
dropped:

	# Set the ingress quota high and use the three egress TCs to limit the
	# amount of traffic that is admitted to the shared buffers. This makes
	# sure that there is always enough traffic of all types to select from
	# for the DWRR process.
	devlink_port_pool_th_set $swp1 0 12
	devlink_tc_bind_pool_th_set $swp1 0 ingress 0 12
	devlink_port_pool_th_set $swp2 4 12
	devlink_tc_bind_pool_th_set $swp2 7 egress 4 5
	devlink_tc_bind_pool_th_set $swp2 6 egress 4 5
	devlink_tc_bind_pool_th_set $swp2 5 egress 4 5

So I'm guessing that this is not the same behavior as in ocelot. But,
truth be told, it doesn't really help either that nfp and mlxsw are
simply passing these parameters to firmware, not really giving any
insight into how they are interpreted.

Would it be simpler if I just exposed these watermarks as generic
devlink resources? Although in a way that would be a wasted opportunity
for devlink-sb. I also don't think I can monitor occupancy if I model
them as generic resources.

Am I missing something?

Thanks,
-Vladimir
