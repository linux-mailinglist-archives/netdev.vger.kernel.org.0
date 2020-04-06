Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B78819F871
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 17:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgDFPDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 11:03:54 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39334 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgDFPDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 11:03:54 -0400
Received: by mail-pg1-f193.google.com with SMTP id g32so38214pgb.6
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 08:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=SbrZS+F0Llk902FcmbDBIxMgSSGWauHaQ4NMG7qYJ1s=;
        b=QSU2uytgJTHSIGB7D65g/g6h0llafL3TksBBPEWYZcqJnF2WsSrgVRa6Pn/AgFr/8u
         TVzvcjksoxSBfiM3C0RA2WO1kT56nh4dccHDgbwp5T+UCdFJYhWqb+8wPvwtHnnWJoqP
         s8gR2wRbJiSnnbYJplc1H/W/mOsEZLib9YE9I6L4tYuOs6TRTd2+dIjL7bUbFFrgVC0M
         t7rc9dT4rHlyEEd5Cvm3gtfvogoqieKqtuAPBI1glcHw7gdVpyn8aexGLSk+HOTIDlJ8
         eu0cv0QZ6rrP8k8Ywp1mc5260dZJM9b964yJ6iQO31kRT/2qMlkGcon1tTTkSfb1MM6P
         yU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=SbrZS+F0Llk902FcmbDBIxMgSSGWauHaQ4NMG7qYJ1s=;
        b=m9qZLZ12g4UXlvg/01Y26GicqrZRBynkQtstcTGMsnjKZhEsfA67mZBEbz+zPaKRpe
         VbBPVY1PFsppYvmd+sKBhK0diNmkxCGgTY4Q+6anZ2wjJc6m89uPdXRg08exOmSwJDMM
         POhreIop3NQ19wopJSNhSh/QQqaH6zBuMbnDV7mJ+GjwPxMaxiCjrHDnp4WC38vahX/L
         xnmYLsIhLF+r+dcoQPEECHWVs1oJZqP1IZavjxy4868P2U2Iyk05XNia27d8cLfD17t1
         EQsRUs33MDHvGzrs8FT33KhZ3dwSc9XMUJZ0uz1Bak1F8RkjC4+37hHe69CjangKS8pl
         mt9w==
X-Gm-Message-State: AGi0PuaW/s2QaaWFds2X4FPASFJHd3y3eehhyTeb2+06qRz1JCeKFUDm
        oTvrQbPTl90725YnnJXRqGvq/Q68dG9zCA==
X-Google-Smtp-Source: APiQypJhTq9AkTVjcSEZZPGVrqBjuyemvBZSK16qCNAgf2Qjy6kjzt5n2tvVcjMsDDRDjlIcOwuLhw==
X-Received: by 2002:aa7:9a92:: with SMTP id w18mr101341pfi.95.1586185432314;
        Mon, 06 Apr 2020 08:03:52 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j24sm6834346pji.20.2020.04.06.08.03.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 08:03:52 -0700 (PDT)
Date:   Mon, 6 Apr 2020 08:03:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 207097] New: recvmsg returning buffer filled with zeros
Message-ID: <20200406080343.2a0c4e7b@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is most likely just a programming error in the sample application.
Someone want to investigate it?

Begin forwarded message:

Date: Sat, 04 Apr 2020 11:00:23 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 207097] New: recvmsg returning buffer filled with zeros


https://bugzilla.kernel.org/show_bug.cgi?id=207097

            Bug ID: 207097
           Summary: recvmsg returning buffer filled with zeros
           Product: Networking
           Version: 2.5
    Kernel Version: 5.3.0-46-generic
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: Lvenkatakumarchakka@gmail.com
        Regression: No

I am creating socket as follows:

=============================

static void create_new_read_socket( const uint64_t card_pos )
{
     const int read_sock = available_cards[card_pos].read_socket = socket(
PF_PACKET, SOCK_RAW|SOCK_NONBLOCK, htons( ETH_P_ALL ) );

     if( read_sock < 0 ) 
     {
          fprintf( stderr, "%s %d Unable to create read_sock", __func__,
__LINE__ );
          return;
     }

     struct ifreq ifr;
     strncpy( ifr.ifr_name, available_cards[card_pos].card_name, IFNAMSIZ );
     if( ioctl( read_sock, SIOCGIFFLAGS, &ifr ) == -1 )
     {
          fprintf( stderr, "%s %d Unable to get flag", __func__, __LINE__ );
          return;
     }
     available_cards[card_pos].ifr_flags_backup = ifr.ifr_flags;
     ifr.ifr_flags |= ( IFF_PROMISC | IFF_UP );
     if( ioctl( read_sock, SIOCSIFFLAGS, &ifr ) == -1 )
     {
          fprintf( stderr, "%s %d Unable to set promiscious flag", __func__,
__LINE__ );
          return;
     }

     struct sockaddr_ll ll =
     {   
          .sll_family = PF_PACKET,
          .sll_protocol = htons(ETH_P_ALL),
          .sll_ifindex = (int)available_cards[card_pos].index
     };            
     if( bind( read_sock, (struct sockaddr *) &ll, sizeof(ll) ) < 0 ) 
     {
          fprintf( stderr, "%s %d Unable to bind", __func__, __LINE__ );
          return;
     }
     const int one = 1;         
     if( setsockopt( read_sock, SOL_PACKET, PACKET_AUXDATA, &one, sizeof(one))
< 0 ) 
     {        
          fprintf( stderr, "%s %d Unable to setsockopt PACKET_AUXDATA",
__func__, __LINE__ );
          return;
     }        
}

=============================

reading the packet as follows:

=============================

read_return = recvmsg( read_socket, &msg, MSG_DONTWAIT );

=============================

I am seeing recvmsg is returning buffer filled with zeros but returning size is
accurate.

-- 
You are receiving this mail because:
You are the assignee for the bug.
