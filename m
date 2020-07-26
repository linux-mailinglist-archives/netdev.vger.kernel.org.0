Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFF622E1DD
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 20:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgGZSFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 14:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgGZSFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 14:05:54 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5712BC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 11:05:54 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k4so6895951pld.12
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 11:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BhCkJZuy4Xqk6xcjPuD08v581LOzX5vm3Q4rfNTkAco=;
        b=iNLCv7SKwPXVAEv+p6Oq1N3erPrh1dVFZj2NHrYAw3cge7Ona4WPFxNfkjcWgbX7vo
         FmUZ7q6knG+a8ssx+tXQjgZj2rV1IFbWbDQ/H5pJ0tOFRZuX4K4uUe5RoNMehYXd1FTc
         iNQiEd4UjZnaztOGghtW1qJ6jAm88lAWAsut3b2Sek+e3OxwphNka29TD2GnFQRsw/4j
         4odv0RU2cATTUjMXbISQK5jPVkDI/3BbP2p6hCYx0mS+wOUeikuXdqsAsxuMpsK+d4OV
         TbUrIPK/VFUMp3L8VM5J/+I+l3BxT7M6u8rIWH6ye1nQZpYPIOFjVAVmSNPWX8Xdx77x
         7W2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BhCkJZuy4Xqk6xcjPuD08v581LOzX5vm3Q4rfNTkAco=;
        b=tqyp4Skcz1QJR8oy2/R3rHVmirsq7ozRsfvA+tN38QXtc12EX0KjRnoLeh7wGWA2X1
         ZLVhFc9S8lKqUOAeuyGahlOdNZdSx4/RdKkmJKCvZHZuxdwyFtxUSny9TxZBo85+qzmr
         mAZdS3LJqFUf6RtnJlVYqGnIqJ3G1rSN6TnJ+Ypxz/mlOonqqJqr9n8wULu90gIjz0of
         2SID00KurhvxwRKiezVUwqRQypzHI+1DocfUatmWozF4MEejqyGS54L8Qh84XlpOsjUL
         EJgkGlOlGy9f9TgkN40YhNgGQi/QzNS1HkwwRUqBQ75ZSybMdQLx1JiZDqlNTdxnTcm0
         oKCQ==
X-Gm-Message-State: AOAM530zGHSP0XzyWIwEoB5c21znjM8QgfzcmovpieoURIwQk287Y9ST
        MA6D/F1lh0TdSlcNbi2Rp6mIxVE2
X-Google-Smtp-Source: ABdhPJxjL/LXAbdSVJKytY4V1qucpmV+Kcdp59Pa/hK8F8/HqhD03EYR0NEiZaRQ12kIo1IR6iBQgQ==
X-Received: by 2002:a17:90a:ac06:: with SMTP id o6mr15108833pjq.219.1595786753694;
        Sun, 26 Jul 2020 11:05:53 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id g18sm12490546pfk.40.2020.07.26.11.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 11:05:53 -0700 (PDT)
Date:   Sun, 26 Jul 2020 11:05:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: phc2sys - does it work?
Message-ID: <20200726180551.GA31684@hoboy>
References: <20200725124927.GE1551@shell.armlinux.org.uk>
 <20200725132916.7ibhnre2be3hfsrt@skbuf>
 <20200726110104.GV1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726110104.GV1605@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 12:01:05PM +0100, Russell King - ARM Linux admin wrote:
> Another solution would be to avoid running NTP on any machine intending
> to be the source of PTP time on a network, but that then brings up the
> problem that you can't synchronise the PTP time source to a reference
> time, which rather makes PTP pointless unless all that you're after is
> "all my local machines say the same wrong time."

It is clear that you can't have two services both adjusting the system
time.  For example, running ntpd and chrony on the same machine won't
work, and neither does running ntpd with 'phc2sys -a -r'.

However, if you want to use NTP as the global time source on a PTP GM,
and you have a heterogeneous collection of PHC cards, then you can run

	phc2sys -a -r -r

(note the two -r flags) and ptp4l with

	boundary_clock_jbod	1
	free_running		1
	priority1		100

for example.  After ptp4l starts, it will need to be configured as a
GM, and for that you will need to provide the kernel with the correct
TAI-UTC offset.  The ntpd program will set this offset, but
unfortunately it waits until it a very long time to do so.  You can
either wait until the kernel reports a non-zero TAI-UTC offset, or you
can script/program the start up logic when starting ptp4l.  See below
for a more or less complete example script.

Just bear in mind that, because phc2sys synchronizes the PHCs to the
NTP system time using software time stamps, there might be a time
error on the order of microseconds.

The reasoning behind the above settings is:

- phc2sys -a -r -r

  Option -a makes phc2sys pay attention to the port state from ptp4l,
  and the first -r lets it synchronize the system time from the port
  with the SLAVE role.  The second -r allows phc2sys to consider the
  system time as a time source, thus when all of the ports take the
  MASTER role, phc2sys with synchronize the PHCs to the system time.

- boundary_clock_jbod=1

  This allows ptp4l to act as a BC or GM using a set of PHCs that do
  not share the same PHC.  The assumption is that some other process
  (like phc2sys or ts2phc) looks after the PHC-to-PHC synchronization.

- free_running=1

  Since the intention is to become the GM, this prevents ptp4l from
  accidentally adjusting the PHCs in the presence of a "better" remote
  GM.

- priority1=100

  This sets a higher priority in order to let the GM win the BMCA
  election.  Still you need to take care not to install a second GM in
  the network at a higher priority.

If the GM has PHCs that are either synchronized in hardware or can be
using internal PPS signals, then the configuration should be
different.  Not sure if that applies to your setup.

HTH,
Richard

---8<---
#!/bin/sh

set -e
set -x

#
# Look here for a hacked version of this program that sets the TAI-UTC offset.
# https://github.com/richardcochran/ntpclient-2015
#
adjtimex=/usr/sbin/adjtimex

#
# Read the leapfile to get the current TAI-UTC offset
#
leapfile=$(awk -e '
{
	if ($1 == "leapfile") print $2;
}
' /etc/ntp.conf)

now=`date +%s`

# NTP/UTC conversion:
# utc = ntp - 2208988800
# ntp = utc + 2208988800

offset=$(awk -v utc_now="$now" -e '
!($1~/^\#/) {
	ntp_leapsecond_date = $1;
	utc_leapsecond_date = ntp_leapsecond_date - 2208988800;
	if (utc_leapsecond_date < utc_now) {
		current_offset = $2;
	}
}
END {
	print current_offset;
}
' $leapfile)

#
# Tell the kernel the current TAI-UTC offset.
#
$adjtimex -T $offset

#
# Tell ptp4l how to act like a Grand Master.
#
while [ 1 ]; do
	if [ -e /var/run/ptp4l ]; then
		break;
	fi
	echo Waiting for /var/run/ptp4l to appear...
	sleep 1
done
exec /usr/sbin/pmc -u -b 0 \
"set GRANDMASTER_SETTINGS_NP
clockClass 248
clockAccuracy 0xfe
offsetScaledLogVariance 0xffff
currentUtcOffset $offset
leap61 0
leap59 0
currentUtcOffsetValid 1
ptpTimescale 1
timeTraceable 1
frequencyTraceable 1
timeSource 0x50
"
