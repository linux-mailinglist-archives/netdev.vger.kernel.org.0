Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18CA128974
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 15:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfLUOPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 09:15:20 -0500
Received: from smtp7.web4u.cz ([81.91.87.87]:51112 "EHLO mx-8.mail.web4u.cz"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726680AbfLUOPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 09:15:18 -0500
Received: from mx-8.mail.web4u.cz (localhost [127.0.0.1])
        by mx-8.mail.web4u.cz (Postfix) with ESMTP id 9C9D7203723;
        Sat, 21 Dec 2019 15:08:41 +0100 (CET)
Received: from thor.pikron.com (unknown [89.102.8.6])
        (Authenticated sender: ppisa@pikron.com)
        by mx-8.mail.web4u.cz (Postfix) with ESMTPA id F384C2036EA;
        Sat, 21 Dec 2019 15:08:40 +0100 (CET)
From:   pisa@cmp.felk.cvut.cz
To:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com, Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v3 6/6] docs: ctucanfd: CTU CAN FD open-source IP core documentation.
Date:   Sat, 21 Dec 2019 15:07:35 +0100
Message-Id: <89c72e45e74236d6f92257c577a5eee8b730b58e.1576922226.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-W4U-Auth: cd5e361db51cadafccf7cdd0bba6b6902a8b876a
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

CTU CAN FD IP core documentation based on Martin Jeřábek's diploma theses
Open-source and Open-hardware CAN FD Protocol Support
https://dspace.cvut.cz/handle/10467/80366
.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Martin Jerabek <martin.jerabek01@gmail.com>
Signed-off-by: Ondrej Ille <ondrej.ille@gmail.com>
---
 .../device_drivers/ctu/FSM_TXT_Buffer_user.png     | Bin 0 -> 174807 bytes
 .../device_drivers/ctu/ctucanfd-driver.rst         | 613 +++++++++++++++++++++
 2 files changed, 613 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ctu/FSM_TXT_Buffer_user.png
 create mode 100644 Documentation/networking/device_drivers/ctu/ctucanfd-driver.rst

diff --git a/Documentation/networking/device_drivers/ctu/FSM_TXT_Buffer_user.png b/Documentation/networking/device_drivers/ctu/FSM_TXT_Buffer_user.png
new file mode 100644
index 0000000000000000000000000000000000000000..5dceb594fca1f668fbc2eb7c1fb5706e99137d28
GIT binary patch
literal 174807
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%0D&FQd-OQSzpwZC;BV%%>A`R#fntBL4Oz3
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%0DI7BLcnK8)91f&y2aG}3b&nOCf?h0^z}XW9OS^I{
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
X{-Q$@1&l2r;Grn1EK@3F9Ps}D^($Z)

literal 0
HcmV?d00001

diff --git a/Documentation/networking/device_drivers/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/ctu/ctucanfd-driver.rst
new file mode 100644
index 000000000000..499bfe0910cd
--- /dev/null
+++ b/Documentation/networking/device_drivers/ctu/ctucanfd-driver.rst
@@ -0,0 +1,613 @@
+CTU CAN FD Driver
+=================
+
+Author: Martin Jerabek <martin.jerabek01@gmail.com>
+
+
+About CTU CAN FD IP Core
+------------------------
+
+`CTU CAN FD <https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core>`_
+is an open source soft core written in VHDL.
+It originated in 2015 as Ondrej Ille's project
+at the `Department of Measurement <https://meas.fel.cvut.cz/>`_
+of `FEE <http://www.fel.cvut.cz/en/>`_ at `CTU <http://www.fel.cvut.cz/en/>`_.
+
+The SocketCAN driver for Xilinx Zynq SoC based MicroZed board has been developed
+as well as support for PCIe integration of the core.
+
+In the case of Zynq, the core is connected via the APB system bus, which does
+not have enumeration support, and the device must be specified in Device Tree.
+This kind of devices is called platform device in the kernel and is
+handled by a platform device driver.
+
+
+About SocketCAN
+---------------
+
+SocketCAN is a standard common interface for CAN devices in the Linux
+kernel. As the name suggests, the bus is accessed via sockets, similarly
+to common network devices. The reasoning behind this is in depth
+described in `Linux SocketCAN <https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/can.rst>`_.
+In short, it offers a
+natural way to implement and work with higher layer protocols over CAN,
+in the same way as, e.g., UDP/IP over Ethernet.
+
+Device probe
+~~~~~~~~~~~~
+
+Before going into detail about the structure of a CAN bus device driver,
+let's reiterate how the kernel gets to know about the device at all.
+Some buses, like PCI or PCIe, support device enumeration. That is, when
+the system boots, it discovers all the devices on the bus and reads
+their configuration. The kernel identifies the device via its vendor ID
+and device ID, and if there is a driver registered for this identifier
+combination, its probe method is invoked to populate the driver's
+instance for the given hardware. A similar situation goes with USB, only
+it allows for device hot-plug.
+
+The situation is different for peripherals which are directly embedded
+in the SoC and connected to an internal system bus (AXI, APB, Avalon,
+and others). These buses do not support enumeration, and thus the kernel
+has to learn about the devices from elsewhere. This is exactly what the
+Device Tree was made for.
+
+Device tree
+~~~~~~~~~~~
+
+An entry in device tree states that a device exists in the system, how
+it is reachable (on which bus it resides) and its configuration –
+registers address, interrupts and so on. An example of such a device
+tree is given in .
+
+.. code:: raw
+
+           / {
+               /* ... */
+               amba: amba {
+                   #address-cells = <1>;
+                   #size-cells = <1>;
+                   compatible = "simple-bus";
+
+                   CTU_CAN_FD_0: CTU_CAN_FD@43c30000 {
+                       compatible = "ctu,ctucanfd";
+                       interrupt-parent = <&intc>;
+                       interrupts = <0 30 4>;
+                       clocks = <&clkc 15>;
+                       reg = <0x43c30000 0x10000>;
+                   };
+               };
+           };
+
+
+.. _sec:socketcan:drv:
+
+Driver structure
+~~~~~~~~~~~~~~~~
+
+The driver can be divided into two parts – platform-dependent device
+discovery and set up, and platform-independent CAN network device
+implementation.
+
+.. _sec:socketcan:platdev:
+
+Platform device driver
+^^^^^^^^^^^^^^^^^^^^^^
+
+In the case of Zynq, the core is connected via the AXI system bus, which
+does not have enumeration support, and the device must be specified in
+Device Tree. This kind of devices is called *platform device* in the
+kernel and is handled by a *platform device driver*\  [1]_.
+
+A platform device driver provides the following things:
+
+-  A *probe* function
+
+-  A *remove* function
+
+-  A table of *compatible* devices that the driver can handle
+
+The *probe* function is called exactly once when the device appears (or
+the driver is loaded, whichever happens later). If there are more
+devices handled by the same driver, the *probe* function is called for
+each one of them. Its role is to allocate and initialize resources
+required for handling the device, as well as set up low-level functions
+for the platform-independent layer, e.g., *read_reg* and *write_reg*.
+After that, the driver registers the device to a higher layer, in our
+case as a *network device*.
+
+The *remove* function is called when the device disappears, or the
+driver is about to be unloaded. It serves to free the resources
+allocated in *probe* and to unregister the device from higher layers.
+
+Finally, the table of *compatible* devices states which devices the
+driver can handle. The Device Tree entry ``compatible`` is matched
+against the tables of all *platform drivers*.
+
+.. code:: c
+
+           /* Match table for OF platform binding */
+           static const struct of_device_id ctucan_of_match[] = {
+               { .compatible = "ctu,canfd-2", },
+               { .compatible = "ctu,ctucanfd", },
+               { /* end of list */ },
+           };
+           MODULE_DEVICE_TABLE(of, ctucan_of_match);
+
+           static int ctucan_probe(struct platform_device *pdev);
+           static int ctucan_remove(struct platform_device *pdev);
+
+           static struct platform_driver ctucanfd_driver = {
+               .probe  = ctucan_probe,
+               .remove = ctucan_remove,
+               .driver = {
+                   .name = DRIVER_NAME,
+                   .of_match_table = ctucan_of_match,
+               },
+           };
+           module_platform_driver(ctucanfd_driver);
+
+
+.. _sec:socketcan:netdev:
+
+Network device driver
+^^^^^^^^^^^^^^^^^^^^^
+
+Each network device must support at least these operations:
+
+-  Bring the device up: ``ndo_open``
+
+-  Bring the device down: ``ndo_close``
+
+-  Submit TX frames to the device: ``ndo_start_xmit``
+
+-  Signal TX completion and errors to the network subsystem: ISR
+
+-  Submit RX frames to the network subsystem: ISR and NAPI
+
+There are two possible event sources: the device and the network
+subsystem. Device events are usually signaled via an interrupt, handled
+in an Interrupt Service Routine (ISR). Handlers for the events
+originating in the network subsystem are then specified in
+``struct net_device_ops``.
+
+When the device is brought up, e.g., by calling ``ip link set can0 up``,
+the driver’s function ``ndo_open`` is called. It should validate the
+interface configuration and configure and enable the device. The
+analogous opposite is ``ndo_close``, called when the device is being
+brought down, be it explicitly or implicitly.
+
+When the system should transmit a frame, it does so by calling
+``ndo_start_xmit``, which enqueues the frame into the device. If the
+device HW queue (FIFO, mailboxes or whatever the implementation is)
+becomes full, the ``ndo_start_xmit`` implementation informs the network
+subsystem that it should stop the TX queue (via ``netif_stop_queue``).
+It is then re-enabled later in ISR when the device has some space
+available again and is able to enqueue another frame.
+
+All the device events are handled in ISR, namely:
+
+#. **TX completion**. When the device successfully finishes transmitting
+   a frame, the frame is echoed locally. On error, an informative error
+   frame [2]_ is sent to the network subsystem instead. In both cases,
+   the software TX queue is resumed so that more frames may be sent.
+
+#. **Error condition**. If something goes wrong (e.g., the device goes
+   bus-off or RX overrun happens), error counters are updated, and
+   informative error frames are enqueued to SW RX queue.
+
+#. **RX buffer not empty**. In this case, read the RX frames and enqueue
+   them to SW RX queue. Usually NAPI is used as a middle layer (see ).
+
+.. _sec:socketcan:napi:
+
+NAPI
+~~~~
+
+The frequency of incoming frames can be high and the overhead to invoke
+the interrupt service routine for each frame can cause significant
+system load. There are multiple mechanisms in the Linux kernel to deal
+with this situation. They evolved over the years of Linux kernel
+development and enhancements. For network devices, the current standard
+is NAPI – *the New API*. It is similar to classical top-half/bottom-half
+interrupt handling in that it only acknowledges the interrupt in the ISR
+and signals that the rest of the processing should be done in softirq
+context. On top of that, it offers the possibility to *poll* for new
+frames for a while. This has a potential to avoid the costly round of
+enabling interrupts, handling an incoming IRQ in ISR, re-enabling the
+softirq and switching context back to softirq.
+
+More detailed documentation of NAPI may be found on the pages of Linux
+Foundation `<https://wiki.linuxfoundation.org/networking/napi>`_.
+
+Integrating the core to Xilinx Zynq
+-----------------------------------
+
+The core interfaces a simple subset of the Avalon
+`Avalon Interface Specifications <https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/manual/mnl_avalon_spec.pdf>`_
+bus as it was originally used on
+Alterra FPGA chips, yet Xilinx natively interfaces with AXI
+`AMBA AXI and ACE Protocol Specification AXI3, AXI4, and AXI4-Lite, ACE and ACE-Lite <https://static.docs.arm.com/ihi0022/d/IHI0022D_amba_axi_protocol_spec.pdf>`_.
+The most obvious solution would be to use
+an Avalon/AXI bridge or implement some simple conversion entity.
+However, the core’s interface is half-duplex with no handshake
+signaling, whereas AXI is full duplex with two-way signaling. Moreover,
+even AXI-Lite slave interface is quite resource-intensive, and the
+flexibility and speed of AXI are not required for a CAN core.
+
+Thus a much simpler bus was chosen – APB (Advanced Peripheral Bus)
+`AMBA APB Protocol Specification v2.0 <https://static.docs.arm.com/ihi0024/c/IHI0024C_amba_apb_protocol_spec.pdf>`_.
+APB-AXI bridge is directly available in
+Xilinx Vivado, and the interface adaptor entity is just a few simple
+combinatorial assignments.
+
+Finally, to be able to include the core in a block diagram as a custom
+IP, the core, together with the APB interface, has been packaged as a
+Vivado component.
+
+CTU CAN FD Driver design
+------------------------
+
+The general structure of a CAN device driver has already been examined
+in . The next paragraphs provide a more detailed description of the CTU
+CAN FD core driver in particular.
+
+Low-level driver
+~~~~~~~~~~~~~~~~
+
+The core is not intended to be used solely with SocketCAN, and thus it
+is desirable to have an OS-independent low-level driver. This low-level
+driver can then be used in implementations of OS driver or directly
+either on bare metal or in a user-space application. Another advantage
+is that if the hardware slightly changes, only the low-level driver
+needs to be modified.
+
+The code [3]_ is in part automatically generated and in part written
+manually by the core author, with contributions of the thesis’ author.
+The low-level driver supports operations such as: set bit timing, set
+controller mode, enable/disable, read RX frame, write TX frame, and so
+on.
+
+Configuring bit timing
+~~~~~~~~~~~~~~~~~~~~~~
+
+On CAN, each bit is divided into four segments: SYNC, PROP, PHASE1, and
+PHASE2. Their duration is expressed in multiples of a Time Quantum
+(details in `CAN Specification, Version 2.0 <http://esd.cs.ucr.edu/webres/can20.pdf>`_, chapter 8).
+When configuring
+bitrate, the durations of all the segments (and time quantum) must be
+computed from the bitrate and Sample Point. This is performed
+independently for both the Nominal bitrate and Data bitrate for CAN FD.
+
+SocketCAN is fairly flexible and offers either highly customized
+configuration by setting all the segment durations manually, or a
+convenient configuration by setting just the bitrate and sample point
+(and even that is chosen automatically per Bosch recommendation if not
+specified). However, each CAN controller may have different base clock
+frequency and different width of segment duration registers. The
+algorithm thus needs the minimum and maximum values for the durations
+(and clock prescaler) and tries to optimize the numbers to fit both the
+constraints and the requested parameters.
+
+.. code:: c
+
+           struct can_bittiming_const {
+               char name[16];      /* Name of the CAN controller hardware */
+               __u32 tseg1_min;    /* Time segement 1 = prop_seg + phase_seg1 */
+               __u32 tseg1_max;
+               __u32 tseg2_min;    /* Time segement 2 = phase_seg2 */
+               __u32 tseg2_max;
+               __u32 sjw_max;      /* Synchronisation jump width */
+               __u32 brp_min;      /* Bit-rate prescaler */
+               __u32 brp_max;
+               __u32 brp_inc;
+           };
+
+
+[lst:can_bittiming_const]
+
+A curious reader will notice that the durations of the segments PROP_SEG
+and PHASE_SEG1 are not determined separately but rather combined and
+then, by default, the resulting TSEG1 is evenly divided between PROP_SEG
+and PHASE_SEG1. In practice, this has virtually no consequences as the
+sample point is between PHASE_SEG1 and PHASE_SEG2. In CTU CAN FD,
+however, the duration registers ``PROP`` and ``PH1`` have different
+widths (6 and 7 bits, respectively), so the auto-computed values might
+overflow the shorter register and must thus be redistributed among the
+two [4]_.
+
+Handling RX
+~~~~~~~~~~~
+
+Frame reception is handled in NAPI queue, which is enabled from ISR when
+the RXNE (RX FIFO Not Empty) bit is set. Frames are read one by one
+until either no frame is left in the RX FIFO or the maximum work quota
+has been reached for the NAPI poll run (see ). Each frame is then passed
+to the network interface RX queue.
+
+An incoming frame may be either a CAN 2.0 frame or a CAN FD frame. The
+way to distinguish between these two in the kernel is to allocate either
+``struct can_frame`` or ``struct canfd_frame``, the two having different
+sizes. In the controller, the information about the frame type is stored
+in the first word of RX FIFO.
+
+This brings us a chicken-egg problem: we want to allocate the ``skb``
+for the frame, and only if it succeeds, fetch the frame from FIFO;
+otherwise keep it there for later. But to be able to allocate the
+correct ``skb``, we have to fetch the first work of FIFO. There are
+several possible solutions:
+
+#. Read the word, then allocate. If it fails, discard the rest of the
+   frame. When the system is low on memory, the situation is bad anyway.
+
+#. Always allocate ``skb`` big enough for an FD frame beforehand. Then
+   tweak the ``skb`` internals to look like it has been allocated for
+   the smaller CAN 2.0 frame.
+
+#. Add option to peek into the FIFO instead of consuming the word.
+
+#. If the allocation fails, store the read word into driver’s data. On
+   the next try, use the stored word instead of reading it again.
+
+Option 1 is simple enough, but not very satisfying if we could do
+better. Option 2 is not acceptable, as it would require modifying the
+private state of an integral kernel structure. The slightly higher
+memory consumption is just a virtual cherry on top of the “cake”. Option
+3 requires non-trivial HW changes and is not ideal from the HW point of
+view.
+
+Option 4 seems like a good compromise, with its disadvantage being that
+a partial frame may stay in the FIFO for a prolonged time. Nonetheless,
+there may be just one owner of the RX FIFO, and thus no one else should
+see the partial frame (disregarding some exotic debugging scenarios).
+Basides, the driver resets the core on its initialization, so the
+partial frame cannot be “adopted” either. In the end, option 4 was
+selected [5]_.
+
+.. _subsec:ctucanfd:rxtimestamp:
+
+Timestamping RX frames
+^^^^^^^^^^^^^^^^^^^^^^
+
+The CTU CAN FD core reports the exact timestamp when the frame has been
+received. The timestamp is by default captured at the sample point of
+the last bit of EOF but is configurable to be captured at the SOF bit.
+The timestamp source is external to the core and may be up to 64 bits
+wide. At the time of writing, passing the timestamp from kernel to
+userspace is not yet implemented, but is planned in the future.
+
+Handling TX
+~~~~~~~~~~~
+
+The CTU CAN FD core has 4 independent TX buffers, each with its own
+state and priority. When the core wants to transmit, a TX buffer in
+Ready state with the highest priority is selected.
+
+The priorities are 3bit numbers in register TX_PRIORITY
+(nibble-aligned). This should be flexible enough for most use cases.
+SocketCAN, however, supports only one FIFO queue for outgoing
+frames [6]_. The buffer priorities may be used to simulate the FIFO
+behavior by assigning each buffer a distinct priority and *rotating* the
+priorities after a frame transmission is completed.
+
+In addition to priority rotation, the SW must maintain head and tail
+pointers into the FIFO formed by the TX buffers to be able to determine
+which buffer should be used for next frame (``txb_head``) and which
+should be the first completed one (``txb_tail``). The actual buffer
+indices are (obviously) modulo 4 (number of TX buffers), but the
+pointers must be at least one bit wider to be able to distinguish
+between FIFO full and FIFO empty – in this situation,
+:math:`txb\_head \equiv txb\_tail\ (\textrm{mod}\ 4)`. An example of how
+the FIFO is maintained, together with priority rotation, is depicted in
+
+|
+
++------+---+---+---+---+
+| TXB# | 0 | 1 | 2 | 3 |
++======+===+===+===+===+
+| Seq  | A | B | C |   |
++------+---+---+---+---+
+| Prio | 7 | 6 | 5 | 4 |
++------+---+---+---+---+
+|      |   | T |   | H |
++------+---+---+---+---+
+
+|
+
++------+---+---+---+---+
+| TXB# | 0 | 1 | 2 | 3 |
++======+===+===+===+===+
+| Seq  |   | B | C |   |
++------+---+---+---+---+
+| Prio | 4 | 7 | 6 | 5 |
++------+---+---+---+---+
+|      |   | T |   | H |
++------+---+---+---+---+
+
+|
+
++------+---+---+---+---+----+
+| TXB# | 0 | 1 | 2 | 3 | 0’ |
++======+===+===+===+===+====+
+| Seq  | E | B | C | D |    |
++------+---+---+---+---+----+
+| Prio | 4 | 7 | 6 | 5 |    |
++------+---+---+---+---+----+
+|      |   | T |   |   | H  |
++------+---+---+---+---+----+
+
+|
+
+.. figure:: FSM_TXT_Buffer_user.png
+
+   TX Buffer states with possible transitions
+
+.. _subsec:ctucanfd:txtimestamp:
+
+Timestamping TX frames
+^^^^^^^^^^^^^^^^^^^^^^
+
+When submitting a frame to a TX buffer, one may specify the timestamp at
+which the frame should be transmitted. The frame transmission may start
+later, but not sooner. Note that the timestamp does not participate in
+buffer prioritization – that is decided solely by the mechanism
+described above.
+
+Support for time-based packet transmission was recently merged to Linux
+v4.19 `Time-based packet transmission <https://lwn.net/Articles/748879/>`_,
+but it remains yet to be researched
+whether this functionality will be practical for CAN.
+
+Also similarly to retrieving the timestamp of RX frames, the core
+supports retrieving the timestamp of TX frames – that is the time when
+the frame was successfully delivered. The particulars are very similar
+to timestamping RX frames and are described in .
+
+Handling RX buffer overrun
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+When a received frame does no more fit into the hardware RX FIFO in its
+entirety, RX FIFO overrun flag (STATUS[DOR]) is set and Data Overrun
+Interrupt (DOI) is triggered. When servicing the interrupt, care must be
+taken first to clear the DOR flag (via COMMAND[CDO]) and after that
+clear the DOI interrupt flag. Otherwise, the interrupt would be
+immediately [7]_ rearmed.
+
+**Note**: During development, it was discussed whether the internal HW
+pipelining cannot disrupt this clear sequence and whether an additional
+dummy cycle is necessary between clearing the flag and the interrupt. On
+the Avalon interface, it indeed proved to be the case, but APB being
+safe because it uses 2-cycle transactions. Essentially, the DOR flag
+would be cleared, but DOI register’s Preset input would still be high
+the cycle when the DOI clear request would also be applied (by setting
+the register’s Reset input high). As Set had higher priority than Reset,
+the DOI flag would not be reset. This has been already fixed by swapping
+the Set/Reset priority (see issue #187).
+
+Reporting Error Passive and Bus Off conditions
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+It may be desirable to report when the node reaches *Error Passive*,
+*Error Warning*, and *Bus Off* conditions. The driver is notified about
+error state change by an interrupt (EPI, EWLI), and then proceeds to
+determine the core’s error state by reading its error counters.
+
+There is, however, a slight race condition here – there is a delay
+between the time when the state transition occurs (and the interrupt is
+triggered) and when the error counters are read. When EPI is received,
+the node may be either *Error Passive* or *Bus Off*. If the node goes
+*Bus Off*, it obviously remains in the state until it is reset.
+Otherwise, the node is *or was* *Error Passive*. However, it may happen
+that the read state is *Error Warning* or even *Error Active*. It may be
+unclear whether and what exactly to report in that case, but I
+personally entertain the idea that the past error condition should still
+be reported. Similarly, when EWLI is received but the state is later
+detected to be *Error Passive*, *Error Passive* should be reported.
+
+
+CTU CAN FD Driver Sources Reference
+-----------------------------------
+
+.. kernel-doc:: ../../driver/ctu_can_fd_hw.h
+   :internal:
+
+.. kernel-doc:: ../../driver/ctu_can_fd.c
+   :internal:
+
+.. kernel-doc:: ../../driver/ctu_can_fd_pci.c
+   :internal:
+
+.. kernel-doc:: ../../driver/ctu_can_fd_platform.c
+   :internal:
+
+CTU CAN FD IP Core and Driver Development Acknowledgement
+---------------------------------------------------------
+
+* Odrej Ille <illeondr@fel.cvut.cz>
+
+  * started the project as student at Department of Measurement, FEE, CTU
+  * invested great amount of personal time and enthusiasm to the project over years
+  * worked on more funded tasks
+
+* `Department of Measurement <https://meas.fel.cvut.cz/>`_,
+  `Faculty of Electrical Engineering <http://www.fel.cvut.cz/en/>`_,
+  `Czech Technical University <https://www.cvut.cz/en>`_
+
+  * is the main investor into the project over many years
+  * uses project in their CAN/CAN FD diagnostics framework for `Skoda Auto <https://www.skoda-auto.cz/>`_
+
+* `Digiteq Automotive <https://www.digiteqautomotive.com/en>`_
+
+  * funding of the project CAN FD Open Cores Support Linux Kernel Based Systems
+  * negotiated and paid CTU to allow public access to the project
+  * provided additional funding of the work
+
+* `Department of Control Engineering <https://dce.fel.cvut.cz/en>`_,
+  `Faculty of Electrical Engineering <http://www.fel.cvut.cz/en/>`_,
+  `Czech Technical University <https://www.cvut.cz/en>`_
+
+  * solving the project CAN FD Open Cores Support Linux Kernel Based Systems
+  * providing GitLab management
+  * virtual servers and computational power for continuous integration
+  * providing hardware for HIL continuous integration tests
+
+* `PiKRON Ltd. <http://pikron.com/>`_
+
+  * minor funding to initiate preparation of the project open-sourcing
+
+* Petr Porazil <porazil@pikron.com>
+
+  * design of PCIe transceiver addon board and assembly of boards
+  * design and assembly of MZ_APO baseboard for MicroZed/Zynq based system
+
+* Martin Jerabek <martin.jerabek01@gmail.com>
+
+  * Linux driver development
+  * continuous integration platform architect and GHDL updates
+  * theses `Open-source and Open-hardware CAN FD Protocol Support <https://dspace.cvut.cz/bitstream/handle/10467/80366/F3-DP-2019-Jerabek-Martin-Jerabek-thesis-2019-canfd.pdf>`_
+
+* Jiri Novak <jnovak@fel.cvut.cz>
+
+  * project initiation, management and use at Department of Measurement, FEE, CTU
+
+* Pavel Pisa <pisa@cmp.felk.cvut.cz>
+
+  * initiate open-sourcing, project coordination, management at Department of Control Engineering, FEE, CTU
+
+* Jaroslav Beran<jara.beran@gmail.com>
+
+ * system integration for Intel SoC, core and driver testing and updates
+
+Notes
+-----
+
+
+.. [1]
+   Other buses have their own specific driver interface to set up the
+   device.
+
+.. [2]
+   Not to be mistaken with CAN Error Frame. This is a ``can_frame`` with
+   ``CAN_ERR_FLAG`` set and some error info in its ``data`` field.
+
+.. [3]
+   Available in in CTU CAN FD repository
+   `<https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core>`_
+
+.. [4]
+   As is done in the low-level driver functions
+   ``ctu_can_fd_set_nom_bittiming`` and
+   ``ctu_can_fd_set_data_bittiming``.
+
+.. [5]
+   At the time of writing this thesis, option 1 is still being used and
+   the modification is queued in gitlab issue #222
+
+.. [6]
+   Strictly speaking, multiple CAN TX queues are supported since v4.19
+   `can: enable multi-queue for SocketCAN devices <https://lore.kernel.org/patchwork/patch/913526/>`_ but no mainline driver is using
+   them yet.
+
+.. [7]
+   Or rather in the next clock cycle
+
-- 
2.11.0

