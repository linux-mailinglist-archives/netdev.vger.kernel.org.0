Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5A879A42
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388031AbfG2UsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:48:00 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:35419 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387803AbfG2UsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:48:00 -0400
Received: by mail-pl1-f181.google.com with SMTP id w24so27955491plp.2;
        Mon, 29 Jul 2019 13:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rrf3YmDySsesPz6r55OZQ0AKfy6F1H52cMUT0s4aiNA=;
        b=RTDyWkL+nHKz9HuiorY/Cr2AWik1RNbNRfajx9D38PfFYq76wplhOAXF1nkiHmIRAt
         sV50Omfzr32r7anvolLARB9CPf23reqVSCHwSxZUNDfJ+yogrv5cUgcB1vRUm3+NNSWq
         vOQX1J5mCW+xxlfTyB7U1uaAyVK5hsW2WyuW6kvFMqyDDGExMHQHjOPHtQTlPkxt4NHu
         wag1URiJWegPZ5XjsfS3Zzg2TVpl8fkhWQhgPEtfyldfprhS9VrTxR2yEctvbdyZ4paX
         2U8Kwg0Lq6NjsGaRvEN5ZgIQ2+/q5oexRiwOf6Aw0ba9MIryZFhCVAlWSxM3A2Y2aEnX
         7Z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rrf3YmDySsesPz6r55OZQ0AKfy6F1H52cMUT0s4aiNA=;
        b=jSsK623wfG4YPiaU04g8tAhFeRMKFULEqX/U1zgbQ1UUCutpKVTitqlggBszhzJEET
         iz8iSUIwdqv2/2iPfqXByNOnjYthN8HOxG2aOuN4Y1+CcPlQ8MAWZULGLdiWkjOZhdTx
         zSx4RD0MptbUSV6wSXVzHMTOvVno1W9tG6W5Un+xc+ch/47duaRIHhDPlipH9WLzIQzg
         k+evViGTZdGnQLoz0ZwtxJVnJrjS+TBtzJTl6VV/Zp2LNMgwEfOPAfM3pkZJrO4CbHAM
         9sxho4Qm45MxeE70suhrV0yCGrbsw5v92zh2Dw9XDzJcSXGYY6XNZPRhXEyPY93oeWsG
         mPDQ==
X-Gm-Message-State: APjAAAXIRmuul8SjZJC/i+KfB1x3i51GiRzp6O4tcPh+CCMF7cQfxFw0
        VxVmsZDGngNEMx6dZrBFt4I=
X-Google-Smtp-Source: APXvYqzdFClt8NZj0Ty9TPln1gms5t6bJ3Rsu6yh4zcbv3KZPSSscDZ7+3Erfy4OsWTZsoJVztoMbA==
X-Received: by 2002:a17:902:f213:: with SMTP id gn19mr115053605plb.35.1564433279524;
        Mon, 29 Jul 2019 13:47:59 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::2:7c6a])
        by smtp.gmail.com with ESMTPSA id 137sm77019728pfz.112.2019.07.29.13.47.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 13:47:58 -0700 (PDT)
Date:   Mon, 29 Jul 2019 13:47:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, edumazet@google.com,
        lmb@cloudflare.com, sdf@google.com, toke@redhat.com,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [bpf-next,v2 0/6] Introduce a BPF helper to generate SYN cookies
Message-ID: <20190729204755.iu5wp3xisu42vkky@ast-mbp>
References: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729165918.92933-1-ppenkov.kernel@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 09:59:12AM -0700, Petar Penkov wrote:
> From: Petar Penkov <ppenkov@google.com>
> 
> This patch series introduces a BPF helper function that allows generating SYN
> cookies from BPF. Currently, this helper is enabled at both the TC hook and the
> XDP hook.
> 
> The first two patches in the series add/modify several TCP helper functions to
> allow for SKB-less operation, as is the case at the XDP hook.
> 
> The third patch introduces the bpf_tcp_gen_syncookie helper function which
> generates a SYN cookie for either XDP or TC programs. The return value of
> this function contains both the MSS value, encoded in the cookie, and the
> cookie itself.
> 
> The last three patches sync tools/ and add a test. 
> 
> Performance evaluation:
> I sent 10Mpps to a fixed port on a host with 2 10G bonded Mellanox 4 NICs from
> random IPv6 source addresses. Without XDP I observed 7.2Mpps (syn-acks) being
> sent out if the IPv6 packets carry 20 bytes of TCP options or 7.6Mpps if they
> carry no options. If I attached a simple program that checks if a packet is
> IPv6/TCP/SYN, looks up the socket, issues a cookie, and sends it back out after
> swapping src/dest, recomputing the checksum, and setting the ACK flag, I
> observed 10Mpps being sent back out.

Is it 10m because trafic gen is 10m?
What is cpu utilization at this rate?
Is it cpu or nic limited if you crank up the syn flood?
Original 7M with all cores or single core?

The patch set looks good to me.
I'd like Eric to review it one more time before applying.

