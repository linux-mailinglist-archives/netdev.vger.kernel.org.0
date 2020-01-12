Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7368138693
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 14:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732845AbgALNGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 08:06:00 -0500
Received: from mail01.vodafone.es ([217.130.24.71]:27585 "EHLO
        mail01.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732705AbgALNF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 08:05:59 -0500
IronPort-SDR: 6BQpUQNjQLh5i+PtOfcQQKJdR4jc1zyqrPfIQ1al/KVGsa9sLMdxxZ143ngPmlVU/K0AOMAa1b
 U1seYiiWu/1g==
IronPort-PHdr: =?us-ascii?q?9a23=3AcFnDLRxdssYYcsrXCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd2+0TIJqq85mqBkHD//Il1AaPAdyAraga26GK7OjJYi8p2d65qncMcZhBBV?=
 =?us-ascii?q?cuqP49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx?=
 =?us-ascii?q?7xKRR6JvjvGo7Vks+7y/2+94fcbglVijexe61+IRS1oAneucQbg5ZpJ7osxB?=
 =?us-ascii?q?fOvnZGYfldy3lyJVKUkRb858Ow84Bm/i9Npf8v9NNOXLvjcaggQrNWEDopM2?=
 =?us-ascii?q?Yu5M32rhbDVheA5mEdUmoNjBVFBRXO4QzgUZfwtiv6sfd92DWfMMbrQ704RS?=
 =?us-ascii?q?iu4qF2QxPujysJKiI2/3vSis1wla5WvhWhpwZnw47TeoGaLuZ+cb3EcdwEQ2?=
 =?us-ascii?q?pNR9pcVzBdAoymc4QPD/QOPeNGoIn7u1sCtAWxBQ+1CO3ozT9IgGH53K0j3+?=
 =?us-ascii?q?s/FwHNwQgsEtwSvHjIqdn4MroZX+Kow6nS1TjNYfNY2S3j5obLbx4uru2DU7?=
 =?us-ascii?q?1rfMrNy0QgCx/JgkmMpYD7OT6ey+QDs3Kc7+plTe+hkXAoqx1vrTi128wjio?=
 =?us-ascii?q?7JhoQaylvZ8ih52Jg6JcGmR05hb9+kF51Qty6BOot2WcMtWH1ntDwmxb0BvJ?=
 =?us-ascii?q?63ZigKyJc+yhPZdveJcJCI7wr9WOqMIzp0nm9pdbyjixqo70StxffwWtep3F?=
 =?us-ascii?q?tIqCdOj8PCuWoX1xPJ78iKUv59/kC81jmRzw3T8eREIVwslarcNp4h3qY8lp?=
 =?us-ascii?q?oNvkTHGS/7gED2g7WXdkUg4Oin9eDnbqnoq5OGKY90jRzxPb4gmsy4B+Q3LB?=
 =?us-ascii?q?ICUHaA+eik1b3j+1P2QKlSg/Eoj6XUsorWKdkVq6KlGQNZzIku5wyhAzu70t?=
 =?us-ascii?q?kUhXwHI0hEeBKDgYjpIVbOIPXgAPennVusjClkx+rIP73mBJXNIWPOkLf6fb?=
 =?us-ascii?q?lm90FQ0hY8zdda555OCrEBI+r/WlXtu9zAEh85Lwu0zv7hCNpjyoMRRHyAAr?=
 =?us-ascii?q?GCPaPMvl+H+PgvL/OPZIALojb9LeYq5/r0gX8+g18dcvrh4ZxCbn2kEvl4C1?=
 =?us-ascii?q?uWbGCqgdobF2oO+A0kQ7/QhUWGQAJUMk6/Q68mrg48Do3uWZ/cH9/93Oza9C?=
 =?us-ascii?q?i+F5xSIGtBDwbfP23vctC8VusBcmqtJclu2mgcWKSsUZAm0x6GtBTwwPxsKe?=
 =?us-ascii?q?+S+i5O5sGr78R8++CGzEJ6zjdzFcnIiDnVQg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HnHQDPGBteR9kYgtkUBjMYGwEBAQE?=
 =?us-ascii?q?BAQEFAQEBEQEBAwMBAQGBaAUBAQELAQEBARgBAQcBgSWBTVIgEo05iAOBSoF?=
 =?us-ascii?q?5i2FnG4IKgRQVhgcUDIFbDQEBAQEBGxoCAQGEQE4BF4EzNQgNAQIDDQEBBQE?=
 =?us-ascii?q?BAQEBBQQBAQIDAQEzhXRCAQEEBwGBTQweAQQBAQEBAwMDAQEMAYNdBxkPOSk?=
 =?us-ascii?q?hTAEOAQRPhU8BATOFOZgkAYQEiQANDQKFHYJJBAqBCYEaI4E2AYwygUE/gUQ?=
 =?us-ascii?q?DgigIAYIBgn8BEgFshSEEjUISIYEHiCmYF4JBBHaJTItnG4I3AQ+IAYQxAxC?=
 =?us-ascii?q?CRQ4BHG2IA4ROgX2jN1d0ATVpcTMagiYagSBPGA2WSECBFhACT4RNgUmFJII?=
 =?us-ascii?q?yAQE?=
X-IPAS-Result: =?us-ascii?q?A2HnHQDPGBteR9kYgtkUBjMYGwEBAQEBAQEFAQEBEQEBA?=
 =?us-ascii?q?wMBAQGBaAUBAQELAQEBARgBAQcBgSWBTVIgEo05iAOBSoF5i2FnG4IKgRQVh?=
 =?us-ascii?q?gcUDIFbDQEBAQEBGxoCAQGEQE4BF4EzNQgNAQIDDQEBBQEBAQEBBQQBAQIDA?=
 =?us-ascii?q?QEzhXRCAQEEBwGBTQweAQQBAQEBAwMDAQEMAYNdBxkPOSkhTAEOAQRPhU8BA?=
 =?us-ascii?q?TOFOZgkAYQEiQANDQKFHYJJBAqBCYEaI4E2AYwygUE/gUQDgigIAYIBgn8BE?=
 =?us-ascii?q?gFshSEEjUISIYEHiCmYF4JBBHaJTItnG4I3AQ+IAYQxAxCCRQ4BHG2IA4ROg?=
 =?us-ascii?q?X2jN1d0ATVpcTMagiYagSBPGA2WSECBFhACT4RNgUmFJIIyAQE?=
X-IronPort-AV: E=Sophos;i="5.69,425,1571695200"; 
   d="scan'208";a="304144559"
Received: from smtp.iservicesmail.com (HELO mailrel03.vodafone.es) ([217.130.24.217])
  by mail01.vodafone.es with ESMTP; 12 Jan 2020 14:05:55 +0100
Received: (qmail 29854 invoked from network); 12 Jan 2020 13:05:51 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel03.vodafone.es (qmail-ldap-1.03) with SMTP
          for <netdev@vger.kernel.org>; 12 Jan 2020 13:05:51 -0000
Date:   Sun, 12 Jan 2020 14:05:53 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <pw178483@gmail.com>
To:     netdev@vger.kernel.org
Message-ID: <32529186.506220.1578834353442.JavaMail.cash@smtp.vodafone.es>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

