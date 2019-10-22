Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A492AE0B82
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387683AbfJVSft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:35:49 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45704 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387598AbfJVSft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:35:49 -0400
Received: by mail-lf1-f67.google.com with SMTP id v8so13333769lfa.12
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=GWU53/ucpAK2ottqYvTgK/qOEwVYaDX3/Iqm8Cqq7vU=;
        b=Vy4bX8RzrwxaQgXV33dB2bjld3U9C8SegUVsGofMiMfSBdiuD0d6zmTCcHGPg/lkF1
         1uqwpo/vIQSeV9n+cJN8Nqssw8qPTFKFaplXJXeb+UsvOdNjUK0Nrvjy5PYw8FPqUY9B
         Ju4jxiFm4sfyuzVp2kyFX7KNrUc4O8e3zMosED352Hor9ZE0AYhNbcI9Jv8icToG0UZG
         bApZ4jAW10Q4DXtNgYmIkxZ0HetlWxug9RC4H78cxqryvkn7FzZjRVqo+JVprpcgYNN1
         x4/JDwAquu9VsJd774TN5pim/6yuqlkBvWe21qYwHMKMv5qAh9eBOpLLly4avo8pL22v
         N1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=GWU53/ucpAK2ottqYvTgK/qOEwVYaDX3/Iqm8Cqq7vU=;
        b=cNshEnRcb3+1JWzlgHgdTt0S+/vG8yejao9tf/ndEaPoIOsnxRs/45816PFxVtgLab
         1cJ8B1OOwZuqXGJwNBAIHi/Z5EO48DWaIHOlXfadIDzJp4DR3/8H2j1yosUxIu59qWsM
         TB3ydMRqcXcJotmwduHXa7O0b20mCM2xaCjRzMgmVHKoiMiRFpU5ThkYe2KfGNbV/Mir
         E+fRyNxYs0YMdmOMGK7BEoxjZMOS30/4jKzD8uzKdIRN0Do74yeAuMkziFoITUuKMnN9
         y8SbR9hUfw41moB8I+k42qdcoNrV1bHoBLkcfJthlUyJORPFeN6sqjBZlzX+0hkzb91U
         mB4A==
X-Gm-Message-State: APjAAAVwhaIlGpDuCPUUJaUdaw8jxDUSZHX6q5ogkZ4a94G8F784iTZS
        kQdyfU4YZ5TJk9WgelTisUyYsQ==
X-Google-Smtp-Source: APXvYqxKvEHOc9V8yLvAZAAAPCoBPy0AxMI5zYWDl4ENBLedtEToYVrDTy6adgMjBrjm+oKHiqDA4w==
X-Received: by 2002:a05:6512:219:: with SMTP id a25mr20111181lfo.155.1571769347265;
        Tue, 22 Oct 2019 11:35:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 71sm10832247lfh.87.2019.10.22.11.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:35:47 -0700 (PDT)
Date:   Tue, 22 Oct 2019 11:35:40 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/2] mlxsw: core: Extend QSFP EEPROM size
Message-ID: <20191022113540.42ac4812@cakuba.netronome.com>
In-Reply-To: <20191021103031.32163-1-idosch@idosch.org>
References: <20191021103031.32163-1-idosch@idosch.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 13:30:29 +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Vadim says:
> 
> This patch set extends the size of QSFP EEPROM for the cable types
> SSF-8436 and SFF-8636 from 256 bytes to 640 bytes. This allows ethtool
> to show correct information for these cable types (more details below).
> 
> Patch #1 adds a macro that computes the EEPROM page number from the
> provided offset specified in the request.
> 
> Patch #2 teaches the driver to access the information stored in the
> upper pages of the QSFP memory map.

Applied, thanks!
