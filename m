Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BC5F9CE6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfKLWW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:22:28 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40225 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKLWW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 17:22:28 -0500
Received: by mail-lj1-f196.google.com with SMTP id q2so214712ljg.7
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 14:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vX4wzp3op3/loo1RCM+LXKXjgadCdjlCLVpUZ293jw4=;
        b=Bgch8T+spbQ5vYsSDbSdL8ZJwxQ3LBa/KsCsmCkEo0MUUKUmtYAbR5n8orvs2bayaq
         FvXIFl/hVp/BluFdzwHmHvfnI/aUMNr8U+aW+RvLicftB5MYnDiDM0PdgjtIi0JBpbb1
         qXddgxlI6fj42485+lfBtZr5L6NXamMOOpPEWYu3g5ezEcPG+V9kp3IGnDuIgSW2prZO
         owhXqKcLMeI/NZRYKxePXpOUBLBpTWTFJAEdjsxTgFfA8ByXc1paU7oOlP19dzBWjbNc
         aWoEonz2gZzExLo/WQK+90M9GZkypVFCzh8HfFpntgaXaMKX+hyjf0ii63r9Df3rBfef
         EmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vX4wzp3op3/loo1RCM+LXKXjgadCdjlCLVpUZ293jw4=;
        b=hr7yzJgaJKB+RPo8hzYz1sIXPJ5nLW3qNxtdB2FyPIoCGtb4FnJsEE4xgYsmBabjC8
         +j2r0REDUP2qN5iN2O+mboQW0FPvCDgN47kPJmfOAQcFiY94BPsq1S2f2VZBXxpICvfy
         ti+e7yZ7YkM9NSPJE1iq+BVaTeY55fnxRpyjwM6C1zuN7nAKMOZ8arVmDdQlB9BGtwcx
         Fa0uxWBhl0IRLbHtpFmEhKNHuftMFDGhIO6dTU8Ax5dOa7QtzB2SJYf8Svu9dN8b4+J5
         6CCJMlIcH+cR8hmkesHt0yGCCrtLuJvXxMqBaBJ+i+qnQ2asJODqV+c/SSSmCdJi3HNS
         AeXw==
X-Gm-Message-State: APjAAAWMhUblLwmZfLs9WkYRfc3tLshNbrGjU3EmeRCZVL4CKKZinBI0
        HSHeRW/8JKBGo3jVOBf/c1WoRhKGeLc=
X-Google-Smtp-Source: APXvYqy40AfW6Yo5QUqqfYuY6Jg0Lx1f2txTb1htySnF6X5LWlhlS8pLdsjaPoFIdIzYXLsQTrFDMQ==
X-Received: by 2002:a2e:8658:: with SMTP id i24mr55670ljj.163.1573597344978;
        Tue, 12 Nov 2019 14:22:24 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q16sm51774lfm.87.2019.11.12.14.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 14:22:24 -0800 (PST)
Date:   Tue, 12 Nov 2019 14:22:18 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 0/7] mlxsw: Add extended ACK for EMADs
Message-ID: <20191112142218.146b0edf@cakuba>
In-Reply-To: <20191112064830.27002-1-idosch@idosch.org>
References: <20191112064830.27002-1-idosch@idosch.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 08:48:23 +0200, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
>=20
> Shalom says:
>=20
> Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
> the driver and device's firmware. They are used to pass various
> configurations to the device, but also to get events (e.g., port up)
> from it. After the Ethernet header, these packets are built in a TLV
> format.
>=20
> Up until now, whenever the driver issued an erroneous register access it
> only got an error code indicating a bad parameter was used. This patch
> set adds a new TLV (string TLV) that can be used by the firmware to
> encode a 128 character string describing the error. The new TLV is
> allocated by the driver and set to zeros. In case of error, the driver
> will check the length of the string in the response and report it using
> devlink hwerr tracepoint.
>=20
> Example:
>=20
> $ perf record -a -q -e devlink:devlink_hwerr &
>=20
> $ pkill -2 perf
>=20
> $ perf script -F trace:event,trace | grep hwerr
> devlink:devlink_hwerr: bus_name=3Dpci dev_name=3D0000:03:00.0 driver_name=
=3Dmlxsw_spectrum err=3D7 (tid=3D9913892d00001593,reg_id=3D8018(rauhtd)) ba=
d parameter (inside er_rauhtd_write_query(), num_rec=3D32 is over the maxim=
um  number of records supported)
>=20
> Patch #1 parses the offsets of the different TLVs in incoming EMADs and
> stores them in the skb's control block. This makes it easier to later
> add new TLVs.
>=20
> Patches #2-#3 remove deprecated TLVs and add string TLV definition.
>=20
> Patches #4-#7 gradually add support for the new string TLV.
>=20
> v2:
> * Use existing devlink hwerr tracepoint to report the error string,
>   instead of printing it to kernel log

Thanks, this is much better! =F0=9F=91=8D
