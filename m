Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25D495195
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 01:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfHSXQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 19:16:24 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]:40736 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbfHSXQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 19:16:24 -0400
Received: by mail-qk1-f182.google.com with SMTP id s145so2949202qke.7
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 16:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/IqcIb5gWs8PF06PhZA43iirSNo2wxOBY1BuyFBCh48=;
        b=cgW6ZuC0/AhpFfVZv/89WhyPgLT7At20080m4HubKSH8Y7uxiaBog9YNAIz/O3aBxr
         ZDoZB0R9HqCLF1+rfPVC8hd1eefHd2AdXnT17wrtQuIEb4FfP5HQ86dWQyxBFX37Xsv7
         sn0PsMR92j4cktInjBRoQK97fU3bJ2dRakyGOJZU4eggnWTvTlp5Hhyoa60vBgv6ayF2
         qk8KkzTR6ETZeGKfQ9kkHVI5R7G+5KjLMd1ewmfeRlD2if1HvDpJeYzusWRomiGxwfGR
         ig5XlrNmrBB1UVKXn5hU4W+ISZnjhcwpw8mztnirX2TvOT8Z9DMXGDF2rWo5jEi6X0lS
         3pag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/IqcIb5gWs8PF06PhZA43iirSNo2wxOBY1BuyFBCh48=;
        b=lzbVxMpIoGiJuSBUkvB/eSyuTOoiOdfA2Om8iyYzOingG7W7gGnRlOBg4rjlCIw3oD
         yDr2uD0J8gVSs6dRks8akCQInLk5fn8WV758mP7FHZpe9ymZR9eDPs4P3eNOJWynvboj
         bt/2YrYIhuEaimQBdsV+1aZLJrPfpGKzk7eYLjGiRpPp73Y853Qq4ObDjt+piCHNZnDI
         ppxOnIOeoHwQaSuld5Xuth2o8Z3hSpvuoQHSSMuzf2MgezENQ3EHIhFsnyroue/srutF
         uB1mbV8Bwhr5eaZdxi5Hy7QeSC1+TuGCcRmnAkkcjWwAeIPlaNUxjsMFuHZrq3UBWs39
         0FRA==
X-Gm-Message-State: APjAAAWi0dKHDw5383OzcWMCyBjoQ4j02QO3lYBIEFclBHCuLE0li73S
        G2cXShfXVMA5dCXamIBYSJdH9A==
X-Google-Smtp-Source: APXvYqzdZnQlbtPe1CrKtAtWABo7V3qonIazak7+2olUdecH3Kj6EDvT48PdRJbtnKhXzobUyPyHbA==
X-Received: by 2002:a37:65d2:: with SMTP id z201mr23087229qkb.413.1566256583523;
        Mon, 19 Aug 2019 16:16:23 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g14sm2615617qki.14.2019.08.19.16.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 16:16:23 -0700 (PDT)
Date:   Mon, 19 Aug 2019 16:16:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v2 00/14][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-08-19
Message-ID: <20190819161616.38c3d8ba@cakuba.netronome.com>
In-Reply-To: <20190819161708.3763-1-jeffrey.t.kirsher@intel.com>
References: <20190819161708.3763-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 09:16:54 -0700, Jeff Kirsher wrote:
> This series contains updates to ice driver only.

FWIW from API perspective this set LGTM, however, the code doesn't
always seem well thought out ;)
