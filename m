Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEAA0EE9ED
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfKDUkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 15:40:05 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38123 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbfKDUkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 15:40:05 -0500
Received: by mail-lf1-f65.google.com with SMTP id q28so13327079lfa.5
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 12:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XvvdyEA22xmsIh4tdjm5q7m2kGN/uu6tRx6IyZ3KJiE=;
        b=mjo7oCnMMhNE423sxzPzoOm/QTWmcPcgAPR8J0kJ08HPEFe7IWWaCXP19Gw/o4NFym
         PSKjnNGSbll4D8ldhpiMxQRm5tbBsWthHcNqnS8Ro9hn/0Q9blP6ugXt7pbmo0rUGchh
         5C/Spe0OVVdJpUWJBDAYmtZaBKe3Al5Yn97YSczsq0p3sIm5XhBzDKtqYDjtrfpm9pIN
         b6iEuJoQayg+2B/QWZ8wqDkNoNJL1ixjt+DE3B7Eow0+trtTA9CyMxKmYo5u8n6zo9Lz
         xKu2LybDeRN0oGuCx1n7KhAaSJ7Z0PngtR8IzjtgOSOpRgBiNf1FUbI4SC2OW5vNh7zS
         mwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XvvdyEA22xmsIh4tdjm5q7m2kGN/uu6tRx6IyZ3KJiE=;
        b=jNFcvhyYe94IEFqtp7ZDrhd2YHP9i2NkQY6GJhad8+h/bwfdz5w3kJF5291KD/vRGK
         OVp8HP7yB2+S0S3XyfszgnN17H0YOaMKUnycRXOUq9u6PV6Y0qf+r2SEFCFH4SbCtSl9
         LxebvsIokO1egdLPLd4XFIqq55WCRjmjimf1XOPRl+EWqYrgduQQIjENB+w+ORHBbDBp
         94DT6TJsu2xkF1nGl4ZLZ3TMu2D7qM9aFxFJxKquC1E6NigKaA8asDu//YHTbnGGurb7
         GYyUg+d8oaaTfAFhAFeYPPc2vJn+fJQmbwD/XbFMiYmveUhkduUNf5GccV3lDPNcXf+z
         KeZg==
X-Gm-Message-State: APjAAAXyNZrzVP8kmo6yi0tiRVRRSjnwuytQ76F+GJYoo4mEOmN1qh2e
        weBrKjLsmf/HppIySx6+zVGRoA7bSCk=
X-Google-Smtp-Source: APXvYqyaLU+MOIB3fAUpX/kroy99AtyKbQDdqlienKhYBDXBQEB6cLwh7h9mLnUyfMhXBOKkNDIgNw==
X-Received: by 2002:a19:41d7:: with SMTP id o206mr17077786lfa.188.1572900003109;
        Mon, 04 Nov 2019 12:40:03 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n1sm2445164ljg.44.2019.11.04.12.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 12:40:02 -0800 (PST)
Date:   Mon, 4 Nov 2019 12:39:54 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191104123954.538d4574@cakuba.netronome.com>
In-Reply-To: <20191103083554.6317-1-idosch@idosch.org>
References: <20191103083554.6317-1-idosch@idosch.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 Nov 2019 10:35:48 +0200, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
> the driver and device's firmware. They are used to pass various
> configurations to the device, but also to get events (e.g., port up)
> from it. After the Ethernet header, these packets are built in a TLV
> format.
> 
> Up until now, whenever the driver issued an erroneous register access it
> only got an error code indicating a bad parameter was used. This patch
> set from Shalom adds a new TLV (string TLV) that can be used by the
> firmware to encode a 128 character string describing the error. The new
> TLV is allocated by the driver and set to zeros. In case of error, the
> driver will check the length of the string in the response and print it
> to the kernel log.
> 
> Example output:
> 
> mlxsw_spectrum 0000:03:00.0: EMAD reg access failed (tid=a9719f9700001306,reg_id=8018(rauhtd),type=query,status=7(bad parameter))
> mlxsw_spectrum 0000:03:00.0: Firmware error (tid=a9719f9700001306,emad_err_string=inside er_rauhtd_write_query(), num_rec=32 is over the maximum number of records supported)

Personally I'm not a big fan of passing unstructured data between user
and firmware. Not having access to the errors makes it harder to create
common interfaces by inspecting driver code.

Is there any precedent in the tree for printing FW errors into the logs
like this?
